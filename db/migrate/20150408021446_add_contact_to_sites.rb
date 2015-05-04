class AddContactToSites < ActiveRecord::Migration
  def change
    add_column :sites, :contact, :text
  end
end
