class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :sites, :slug, unique: true
  end
end
