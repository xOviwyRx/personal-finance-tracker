class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do
    render json: { error: 'Access denied' }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  attr_reader :current_user

  private

  def authenticate_user!
    payload = JwtService.decode(bearer_token)
    return render_unauthorized('Invalid token') unless payload
    return render_unauthorized('Token has been revoked') if JwtDenylist.exists?(jti: payload['jti'])

    @current_user = User.find_by(id: payload['sub'])
    render_unauthorized('Invalid token') unless @current_user
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  def bearer_token
    request.headers['Authorization']&.sub(/^Bearer /, '')
  end

  def render_unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end

  def record_not_found(_exception)
    render json: { error: 'Record not found' }, status: :not_found
  end
end
