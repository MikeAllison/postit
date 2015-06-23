class AddFlagsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :flags_count, :integer
  end
end
