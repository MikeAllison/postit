class AddIndexes < ActiveRecord::Migration
  def change
    add_index :categories, :slug

    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index :comments, :created_at

    add_index :flags, :user_id
    add_index :flags, [:flagable_id, :flagable_type]

    add_index :post_categories, :post_id
    add_index :post_categories, :category_id

    add_index :posts, :user_id
    add_index :posts, :created_at
    add_index :posts, :slug

    add_index :users, :slug

    add_index :votes, :user_id
    add_index :votes, [:voteable_id, :voteable_type]
  end
end
