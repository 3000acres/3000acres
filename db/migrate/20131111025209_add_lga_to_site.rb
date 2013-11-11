class AddLgaToSite < ActiveRecord::Migration
  def change
    add_column :sites, :local_government_area_id, :integer
  end
end
