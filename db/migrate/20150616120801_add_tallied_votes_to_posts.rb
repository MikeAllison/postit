class AddTalliedVotesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :tallied_votes, :integer
  end
end
