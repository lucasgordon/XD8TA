class AnalyticsChatsController < ApplicationController

  before_action :set_analytics_chat, only: [:show, :create_message]

  def show
    @messages = @analytics_chat.messages
    @message = Message.new
    @analytic = @analytics_chat.analytic
  end

  def create_message
    @message = @analytics_chat.messages.build(message_params)
    if @message.save
      #response = PromptService.get_response(@message.user_prompt)
      #@message.update(agent_response: response)
      redirect_to analytics_chat_path(@analytics_chat), notice: 'Message was successfully created.'
    else
      render :show
    end
  end


  private

  def set_analytics_chat
    @analytics_chat = AnalyticsChat.find(params[:id])
  end

  def analytics_chat_params
    params.require(:analytics_chat).permit(:prompt_temperature, :user_id, :analytic_id, :analytic_type)
  end

  def message_params
    params.require(:message).permit(:user_prompt)
  end

end
