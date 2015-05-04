class AddFacebookurlToSites < ActiveRecord::Migration
  def change
    add_column :sites, :facebook_id, :integer
  end
end
