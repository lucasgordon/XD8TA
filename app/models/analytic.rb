class Analytic < ApplicationRecord
  belongs_to :user
  has_one :analytics_chat, as: :analytic

  enum title: {
    top_overall: "Top Overall",
    worst_overall: "Worst Post",
  }

  validates :title, presence: true
  validates :title, inclusion: { in: titles.keys }
end
