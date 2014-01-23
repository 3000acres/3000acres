class AddWebsiteToSite < ActiveRecord::Migration
  def change
    add_column :sites, :website, :string
  end
end
