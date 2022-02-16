class Article < ApplicationRecord
  has_one :article_statistic, dependent: :destroy
  has_many :comments, dependent: :destroy

  # 誤って外部から保存されるのを防ぐため意味わからんバリテーション設定
  validates :title, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
