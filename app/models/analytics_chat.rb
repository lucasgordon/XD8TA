class AnalyticsChat < ApplicationRecord
  belongs_to :analytic, polymorphic: true
end
