class RemoveSiteIdFromCustomers < ActiveRecord::Migration[7.1]
  def change
    remove_reference :customers, :site, foreign_key: true
  end
end
