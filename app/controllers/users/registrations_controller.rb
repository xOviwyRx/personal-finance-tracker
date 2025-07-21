# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 201, message: 'Signed up successfully.' },
        data: { user: resource.as_json(only: [:id, :email]) }
      }, status: :created
    else
      render json: {
        status: { message: "User couldn't be created. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
