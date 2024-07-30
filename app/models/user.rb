class User < ApplicationRecord
  has_secure_password

  validates :name, :email, :x_username, presence: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  has_many :posts

  has_many :analytics, dependent: :destroy

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
      end
    end
  end

  private

  def fetch_analysis(title)
    prompt = Prompts::PersonalPostAnalysisPrompt.new(self)

    response = PromptService.new(content: prompt.user_prompt, system: prompt.system_prompt_generator(title), model: "claude-3-5-sonnet-20240620").prompt

    response["content"].first["text"]
  end
end
