class AccountXProfile < ApplicationRecord
  validates :x_username, presence: true, uniqueness: true
end
