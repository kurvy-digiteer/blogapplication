class AddSiteToUsers < ActiveRecord::Migration[8.0]
  def up
    # 1. Add site_id as nullable
    add_reference :users, :site, null: true

    # 2. Use the default site (created earlier or fallback)
    site = Site.first || Site.create!(name: 'Default Site', slug: 'default-site')

    # 3. Backfill all users with the default site
    User.reset_column_information
    User.where(site_id: nil).update_all(site_id: site.id)

    # 4. Set NOT NULL and add foreign key
    change_column_null :users, :site_id, false
    add_foreign_key :users, :sites
  end

  def down
    remove_foreign_key :users, :sites
    remove_reference :users, :site
  end
end
