class ApplicationController < ActionController::API
    before_action :authenticate_user!
    include CanCan::ControllerAdditions
    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access denied' }, status: :forbidden
    end
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

    def authenticate_user!
        token = token_from_request
        return render json: { error: 'Missing token' }, status: :unauthorized unless token

        begin
            decoded_token = Warden::JWTAuth::TokenDecoder.new.call(token)
            jti = decoded_token['jti']
            user_id = decoded_token['sub']
            return render json: { error: 'Token has been revoked' }, status: :unauthorized if JwtDenylist.exists?(jti: jti)

            @current_user = User.find(user_id)
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end

    attr_reader :current_user

    def current_ability
        @current_ability ||= ::Ability.new(current_user)
    end

    def token_from_request
        pattern = /^Bearer /
        header = request.headers['Authorization']
        header.gsub(pattern, '') if header&.match(pattern)
    end

    def record_not_found(_exception)
        render json: { error: 'Record not found' }, status: :not_found
    end
end
