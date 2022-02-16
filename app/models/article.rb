class Article < ApplicationRecord
  has_one :article_statistic, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
end
