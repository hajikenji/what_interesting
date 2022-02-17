class Article < ApplicationRecord
  has_one :article_statistic, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true

  scope :order_fav, -> { joins(:article_statistic).all.order(fav: "DESC") }
  scope :where_totay_articles, -> { where(created_at: Time.zone.today..Time.now) }
end
