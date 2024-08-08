class AnalyticsChatsController < ApplicationController

  before_action :set_analytics_chat, only: [:create_message]

  def new
    @analytics_chat = AnalyticsChat.new
    @user = current_user
  end

  def create
    @analytics_chat = AnalyticsChat.new(analytic_chat_params)
    @analytics_chat.chat_type = current_user.x_username == analytic_chat_params[:x_username] ? "Personal" : "Public"
    @analytics_chat.user_id = current_user.id
    @analytics_chat.prompt_temperature = "0.5"
    @analytics_chat.save!

    if Post.where(x_username: @analytics_chat.x_username).empty?
      twitter_api = XClient.new(@analytics_chat.x_username)
      twitter_api.fetch_public_metrics
    end

    redirect_to analytics_user_path(current_user, chat_id: @analytics_chat.id)
  end



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

  def analytic_chat_params
    params.require(:analytics_chat).permit(:x_id, :x_username)
  end

end
