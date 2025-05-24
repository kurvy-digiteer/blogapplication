class RemoveSiteIdFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_reference :comments, :site, foreign_key: true
  end
end
