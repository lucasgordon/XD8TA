class AnalyticsChat < ApplicationRecord
  belongs_to :user

  validates :user_id, :chat_type, presence: true

  validates :chat_type, inclusion: { in: ["Personal", "Public"] }

  has_many :messages, dependent: :destroy

  def analytic_chat_system_prompt
    prompt = Prompts::AnalyticsChatPrompt.new(self)
    prompt.system_prompt
  end

  def fetch_chat_response(message)
    response = PromptService.new(content: message.user_prompt, system: analytic_chat_system_prompt, temperature: 0.5, model: "gpt-4o").prompt
    # response["content"].first["text"] -> Claude
    response["choices"][0]["message"]["content"]
  end
end
