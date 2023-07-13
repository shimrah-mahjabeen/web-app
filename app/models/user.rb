class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]
  has_one :profile
  has_many :ratings

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        user_name: data['nickname'],
        email: data['email'],
        password: Devise.friendly_token[0,20],
        github_token: access_token.credentials.token # store the token
      )
    else
      user.update(github_token: access_token.credentials.token) # update the token if user already exists
    end

    user
  end
end
