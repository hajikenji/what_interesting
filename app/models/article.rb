class Article < ApplicationRecord
  has_one :article_statistic, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true

  scope :order_fav, -> { eager_load(:article_statistic).all.order(fav: "DESC") }
  scope :where_24hour_articles, -> { where(created_at: Time.now.yesterday..Time.now) }
  scope :where_1week_articles, -> { where(created_at: Time.now.ago(7.days)..Time.now) }
end
