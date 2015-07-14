class AddOptionalIndexes < ActiveRecord::Migration
  def change
    add_index :comments, :hidden
    add_index :posts, :hidden

    add_index :comments, [:tallied_votes, :created_at]
    add_index :posts, [:tallied_votes, :created_at]

    add_index :posts, :total_flags
    add_index :comments, :total_flags

    add_index :flags, [:user_id, :flag]
  end
end
