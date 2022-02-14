class Article < ApplicationRecord
  has_one :article_statistic
  has_many :comments

  #誤って外部から保存されるのを防ぐため意味わからんバリテーション設定
  validates :title, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
