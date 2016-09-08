class AddHiddenToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :hidden, :boolean
  end
end
