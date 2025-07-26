module AuthHelpers
  def auth_headers_for(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { Authorization: "Bearer #{token}" }
  end
end
