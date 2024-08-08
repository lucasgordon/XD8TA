class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :x_username, presence: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  has_many :posts

  has_many :analytics_chats

  after_create :fetch_profile_information

  def fetch_profile_information
    x_client = XClient.new(self)
    x_client.fetch_user_information(self)
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
