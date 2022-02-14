class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :content, length: { in: 5..15 }
  validates :user_id, uniqueness: { scope: :article_id, message: 'のコメントはすでに存在します' }
end
