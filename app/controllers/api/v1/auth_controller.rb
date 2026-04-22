class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login, :signup]

  def login
    user = User.find_by(email: auth_params[:email])

    if user&.authenticate(auth_params[:password])
      render json: issue_token(user)
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(signup_params)

    if user.save
      render json: issue_token(user), status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    payload = JwtService.decode(bearer_token)
    JwtDenylist.create!(jti: payload['jti'], exp: Time.at(payload['exp'])) if payload

    render json: { message: 'Logged out successfully' }
  end

  private

  def issue_token(user)
    {
      token: JwtService.encode(user),
      user: { id: user.id, email: user.email }
    }
  end

  def auth_params
    params.require(:user).permit(:email, :password)
  end

  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
