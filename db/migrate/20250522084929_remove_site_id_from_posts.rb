class RemoveSiteIdFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :site_id, :integer
  end
end
