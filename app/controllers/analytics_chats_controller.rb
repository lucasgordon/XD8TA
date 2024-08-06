class AnalyticsChatsController < ApplicationController

  before_action :set_analytics_chat, only: [:show, :create_message]


  def create_message

    @message = @analytics_chat.messages.build(message_params)
    if @message.save
      text_response = @analytics_chat.fetch_chat_response(@message)
      @message.update(agent_response: text_response)

      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  def create
    @analytics_chat = current_user.analytics_chats.create!(chat_type: params[:chat_type], prompt_temperature: 0.5, x_id: params[:x_id], x_username: params[:x_username])
    redirect_to analytics_user_path(current_user, chat_id: @analytics_chat.id)
  end


  private

  def set_analytics_chat
    @analytics_chat = AnalyticsChat.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:user_prompt)
  end

end
