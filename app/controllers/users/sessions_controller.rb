# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: sign_in_params[:email])

    if user&.valid_password?(sign_in_params[:password])
      self.resource = user
      sign_in(resource_name, resource)
      respond_with(resource)
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: { user: resource.as_json(only: [:id, :email]) }
    }
  end

  def respond_to_on_destroy
    render json: {
      status: { code: 200, message: 'Logged out successfully.' }
    }
  end
end
