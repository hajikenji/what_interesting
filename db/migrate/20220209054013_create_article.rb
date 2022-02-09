class CreateArticle < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :link
      t.text :icon
      t.integer :ranking
      t.timestamps
    end
  end
end
