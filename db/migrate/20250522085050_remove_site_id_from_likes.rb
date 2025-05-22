class RemoveSiteIdFromLikes < ActiveRecord::Migration[7.1]
  def change
    remove_reference :likes, :site, foreign_key: true
  end
end
