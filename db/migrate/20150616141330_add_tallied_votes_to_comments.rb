class AddTalliedVotesToComments < ActiveRecord::Migration
  def change
    add_column :comments, :tallied_votes, :integer
  end
end
