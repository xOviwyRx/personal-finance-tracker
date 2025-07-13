class ApplicationController < ActionController::API
    before_action :authenticate_user!
    include CanCan::ControllerAdditions
    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access denied' }, status: :forbidden
    end
end
