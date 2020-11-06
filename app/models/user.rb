class User < ApplicationRecord
  has_secure_password
  has_many :posts
  validates :username , uniqueness: true , length: {minimum: 5}
  validates :password , length: {minimum: 5}
  validates :email , uniqueness: true , length: {minimum: 5}

  def auth_by_email(email , password)
    #finding user and validating password
    user=User.find_by(email: email)
              .try(:authenticate , password)
  end

  def auth_by_token(token)
    if token.present? 
      begin
        #validating and decoding token
        secret_key= Rails.application.secrets.secret_key_base[0]
        decoded_token = JWT.decode(token, secret_key)[0]    #recieving data hash from the token
        return User.find_by(email: decoded_token['email'])
      rescue  JWT::DecodeError
        #JWT::ExpiredSignature , JWT::ImmatureSignature , JWT::InvalidIssuerError , JWT::VerificationError,
        return nil
      end
    end
  end

  def data
    #generating user info and token
    exp= 1.days.from_now.to_i
    secret_key= Rails.application.secrets.secret_key_base[0]
    user_data= {username: self.username , email: self.email , exp: exp} 
    token = JWT.encode(user_data , secret_key)
    user_data['token'] = token
    return user_data
  end


end
