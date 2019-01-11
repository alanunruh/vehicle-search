class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string  :vin, null: false
      t.string  :make, null: false
      t.string  :model, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
