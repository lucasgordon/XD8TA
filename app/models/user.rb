class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :password, :x_username, presence: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  has_many :posts


end
