class AddUnhiddenPostsCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :unhidden_posts_count, :integer
    remove_column :categories, :posts_count
  end
end
