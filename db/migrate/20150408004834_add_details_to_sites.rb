class AddDetailsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :facebook, :string
    add_column :sites, :featured, :boolean
  end
end
