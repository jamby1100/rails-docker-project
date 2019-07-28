class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :author, foreign_key: true
      t.integer :likes_count

      t.timestamps
    end
  end
end
