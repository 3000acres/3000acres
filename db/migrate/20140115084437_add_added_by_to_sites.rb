class AddAddedByToSites < ActiveRecord::Migration
  def change
    add_column :sites, :added_by_user_id, :integer
  end
end
