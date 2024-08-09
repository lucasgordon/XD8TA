class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :x_username, presence: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  has_many :posts

  has_many :analytics_chats

  after_create :fetch_profile_information
  after_create :fetch_user_posts

  def fetch_profile_information
    x_client = XClient.new(username: self.x_username, user: self)
    x_client.fetch_user_information
  end

  def fetch_user_posts
    x_client = XClient.new(username: self.x_username, user: self)
    x_client.fetch_public_metrics
  end

  def generate_analytics
    Analytic.titles.keys.each do |title|
      analytic = self.analytics.build(
        title: title
      )

      if analytic.save!
        body = fetch_analysis(title)

        analytic.update!(body: body)

        AnalyticsChat.create!(
          user: self,
          analytic: analytic,
          prompt_temperature: 0.5,
        )
      end

      sleep(5)
    end
  end

  private
end
