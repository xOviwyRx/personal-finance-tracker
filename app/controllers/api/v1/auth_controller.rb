class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login, :signup]
  def login
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)

    if user.save
      token, *payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def logout
    render json: { message: 'Logged out successfully' }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end