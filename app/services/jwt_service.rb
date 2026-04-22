class JwtService
  EXPIRATION = 24.hours

  class << self
    def encode(user)
      payload = {
        sub: user.id,
        jti: SecureRandom.uuid,
        exp: EXPIRATION.from_now.to_i
      }
      JWT.encode(payload, secret, 'HS256')
    end

    def decode(token)
      payload, = JWT.decode(token, secret, true, algorithm: 'HS256')
      payload
    rescue JWT::DecodeError
      nil
    end

    private

    def secret
      Rails.application.secret_key_base
    end
  end
end
