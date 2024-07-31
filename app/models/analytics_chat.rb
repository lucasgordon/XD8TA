class AnalyticsChat < ApplicationRecord
  belongs_to :analytic, polymorphic: true
  belongs_to :user

  validates :analytic_id, :user_id, presence: true

  has_many :messages, dependent: :destroy
end
