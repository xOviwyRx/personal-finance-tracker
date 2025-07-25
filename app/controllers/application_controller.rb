class ApplicationController < ActionController::API
    before_action :authenticate_user!
    include CanCan::ControllerAdditions
    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access denied' }, status: :forbidden
    end

    private

    def authenticate_user!
        token = token_from_request
        return render json: { error: 'Missing token' }, status: :unauthorized unless token

        begin
            decoded_token = Warden::JWTAuth::TokenDecoder.new.call(token)
            user_id = decoded_token['sub']
            @current_user = User.find(user_id)
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end

    def current_user
        @current_user
    end

    def current_ability
        @current_ability ||= ::Ability.new(current_user)
    end

    def token_from_request
        pattern = /^Bearer /
        header = request.headers['Authorization']
        header.gsub(pattern, '') if header&.match(pattern)
    end
end
