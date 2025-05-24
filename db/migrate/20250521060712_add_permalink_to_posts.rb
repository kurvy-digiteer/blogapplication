class AddPermalinkToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :permalink, :string
    add_index :posts, :permalink, unique: true
  end
end
