# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

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
