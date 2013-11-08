class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :suburb
      t.float :latitude
      t.float :longitude
      t.decimal :size
      t.boolean :water
      t.date :available_until
      t.string :status

      t.timestamps
    end
  end
end
