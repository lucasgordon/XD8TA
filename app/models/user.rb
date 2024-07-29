class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :x_username, presence: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  has_many :posts

  after_create :fetch_profile_information

  def fetch_profile_information
    x_client = XClient.new(self)
    x_client.fetch_user_information(self)
  end

end
