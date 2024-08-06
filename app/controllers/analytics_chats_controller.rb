class AnalyticsChatsController < ApplicationController

  before_action :set_analytics_chat, only: [:show, :create_message]


  def create_message

    @message = @analytics_chat.messages.build(message_params)
    if @message.save

      call_agent_response

      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  def call_agent_response
    text_response = @analytics_chat.fetch_chat_response(@message)
    @message.update(agent_response: text_response)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @chats = current_user.analytics_chats.where(chat_type: "Personal").order(created_at: :desc)
    @new_chat = current_user.analytics_chats.create!(chat_type: params[:chat_type], prompt_temperature: 0.5, x_id: params[:x_id], x_username: params[:x_username])
    respond_to do |format|
      format.html { redirect_to analytics_user_path(current_user, chat_id: @new_chat.id) }
      format.turbo_stream
    end
  end

  def reset_chat
    @analytics_chat = AnalyticsChat.find(params[:id])
    @analytics_chat.messages.destroy_all

    respond_to do |format|
      format.html { redirect_to analytics_user_path(current_user, chat_id: @analytics_chat.id) }
    end
  end

  def destroy
    @analytics_chat = AnalyticsChat.find(params[:id])
    @analytics_chat.destroy
    respond_to do |format|
      format.html { redirect_to analytics_user_path(current_user) }
    end
  end


  private

  def set_analytics_chat
    @analytics_chat = AnalyticsChat.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:user_prompt)
  end

end
