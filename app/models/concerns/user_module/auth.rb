module UserModule
  module Auth
    extend ActiveSupport::Concern
    
    def has_password?(password)
      BCrypt::Password.new(crypted_password) == password
    end

    def encrypt_password
      self.crypted_password = BCrypt::Password.create(password) if password.present?
    end

    def generate_token
      tokens.destroy_all
      expiry_date = Time.now + 1.weeks
      payload = { identifier: self.id, expiry_date: expiry_date }
      token = JWT.encode(payload, 'SIGNATURE-KEY-BASE', 'HS256')
      tokens.create( kind: 'jwt', token: token, expiry_date: expiry_date)
    end
  end
end