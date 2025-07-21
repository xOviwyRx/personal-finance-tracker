class ApplicationController < ActionController::API
    before_action :authenticate_api_v1_user!
    include CanCan::ControllerAdditions
    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access denied' }, status: :forbidden
    end

    private
    def current_user
        current_api_v1_user
    end

    def current_ability
        @current_ability ||= ::Ability.new(current_user)
    end
end
