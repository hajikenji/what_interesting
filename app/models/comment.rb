class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :content, length: { in: 5..15 }
  validates :article_id, uniqueness: { scope: :user_id }
end
