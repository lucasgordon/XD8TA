class PublicAnalyticsController < ApplicationController
  def index
    @public_analytics = PublicAnalytic.all
  end
end
