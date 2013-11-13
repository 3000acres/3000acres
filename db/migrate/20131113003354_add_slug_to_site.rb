class AddSlugToSite < ActiveRecord::Migration
  def change
    add_column :sites, :slug, :string
    add_index :sites, :slug, unique: true
  end
end
