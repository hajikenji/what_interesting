class ChangeDataArticleStatistic < ActiveRecord::Migration[6.0]
  def change
    change_column :article_statistics, :comment, "integer USING comment::integer"
  end
end
