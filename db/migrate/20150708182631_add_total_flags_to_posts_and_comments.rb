class AddTotalFlagsToPostsAndComments < ActiveRecord::Migration
  def change
    add_column :posts, :total_flags, :integer
    add_column :comments, :total_flags, :integer
  end
end
