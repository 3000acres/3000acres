class AddFacebookIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :facebook_id, :bigint
  end
end
