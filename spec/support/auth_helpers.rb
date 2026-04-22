module AuthHelpers
  def auth_headers_for(user)
    token = JwtService.encode(user)
    { Authorization: "Bearer #{token}" }
  end
end
