class RemoveSitesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :sites
  end
end
