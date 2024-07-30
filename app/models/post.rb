class Post < ApplicationRecord
  belongs_to :user, optional: true

  validates :post_id, uniqueness: true

  has_many :post_mentions, dependent: :destroy
  has_many :entities_annotations, dependent: :destroy
  has_many :context_annotation_domains, dependent: :destroy
end
