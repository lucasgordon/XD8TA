
require "anthropic"
require 'cohere'

class PromptService
  TEMPERATURE_RANGE = 0.0..1.0

  MODELS = [
    "command-r-plus",
    "claude-3-5-sonnet-20240620",
    "gpt-4o"
  ].freeze

  COHERE_MODELS = [
    "command-r-plus"
  ].freeze

  CLAUDE_MODELS = [
  "claude-3-5-sonnet-20240620"
  ].freeze

  OPENAI_MODELS = [
    "gpt-4o"
  ].freeze

  MAX_RETRIES = 5

  class << self
    def prompt(...)
      new(...).prompt
    end
  end

  def initialize(content:, system: nil, model: "gpt-4o", temperature: 0.5, format: nil)
    raise ArgumentError, "Invalid model" unless MODELS.include?(model)
    raise ArgumentError, "Invalid temperature" unless TEMPERATURE_RANGE.include?(temperature)

    @content = content
    @system = system
    @model = model
    @temperature = temperature
    @format = format
  end

  def prompt
    retries = 0
    begin
      if COHERE_MODELS.include?(@model)
        cohere_client.chat(**cohere_params)
      elsif CLAUDE_MODELS.include?(@model)
        claude_client.messages(parameters: claude_params)
      elsif OPENAI_MODELS.include?(@model)
        openai_client.chat(parameters: openai_params)
      else
        raise "Unsupported model"
      end
    rescue Faraday::TooManyRequestsError => e
      retries += 1
      if retries < MAX_RETRIES
        sleep(2**retries)
        retry
      else
        raise e
      end
    end
  end

  def cohere_client
    @cohere_client ||= Cohere::Client.new(api_key: ENV['COHERE_API_KEY'])
  end

  def claude_client
    @claude_client ||= Anthropic::Client.new
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def openai_params
    messages = []
    messages << { role: "system", content: @system } if @system.present?
    messages << { role: "user", content: @content }
    {
      model: @model,
      messages: messages,
      temperature: @temperature,
    }
  end


  def claude_params
    messages = []
    messages << { role: "user", content: @content }
    {
      model: @model,
      system: @system,
      messages: messages,
      max_tokens: 1000
    }

  end

  def cohere_params
    preamble = @system.present? ? @system : ""
    {
      model: @model,
      preamble: preamble,
      message: @content,
      temperature: @temperature
    }
  end

  def json_format
    { response_format: { type: "json_object" } }
  end
end
