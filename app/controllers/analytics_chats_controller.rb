class AnalyticsChatsController < ApplicationController

  before_action :set_analytics_chat, only: [:show, :create_message]

  def show
    @messages = @analytics_chat.messages
    @message = Message.new
    @analytic = @analytics_chat.analytic
    @analytic_body = @analytic.body

    @username = @analytics_chat.analytic.user ? @analytics_chat.analytic.user.x_username : @analytics_chat.analytic.x_username
  end

  def create_message

    @message = @analytics_chat.messages.build(message_params)
    if @message.save
      text_response = @analytics_chat.fetch_chat_response(@message)
      @message.update(agent_response: text_response)
      redirect_to analytics_chat_path(@analytics_chat)
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
