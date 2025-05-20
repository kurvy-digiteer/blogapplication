class AddFlagsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :active, :boolean
    add_column :posts, :feature, :boolean
  end
end
