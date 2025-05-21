class AddSiteToCustomers < ActiveRecord::Migration[8.0]
  def up
    # 1. Add site_id as nullable
    add_reference :customers, :site, null: true

    # 2. Use the default site (created earlier or fallback)
    site = Site.first || Site.create!(name: 'Default Site', slug: 'default-site')

    # 3. Backfill all customers with the default site
    Customer.reset_column_information
    Customer.where(site_id: nil).update_all(site_id: site.id)

    # 4. Set NOT NULL and add foreign key
    change_column_null :customers, :site_id, false
    add_foreign_key :customers, :sites
  end

  def down
    remove_foreign_key :customers, :sites
    remove_reference :customers, :site
  end
end
