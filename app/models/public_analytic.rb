class PublicAnalytic < ApplicationRecord
  has_many :posts, foreign_key: :x_id
  has_one :analytics_chat, as: :analytic
end
