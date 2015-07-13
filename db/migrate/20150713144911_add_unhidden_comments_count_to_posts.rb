class AddUnhiddenCommentsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :unhidden_comments_count, :integer
    remove_column :posts, :comments_count
  end
end
