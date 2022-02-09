class CreateArticleStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :article_statistics do |t|
      t.string :comment
      t.integer :fav
      t.integer :comment_fav
      t.integer :quote
      t.references :article, foreign_key: true
      t.timestamps
    end
  end
end
