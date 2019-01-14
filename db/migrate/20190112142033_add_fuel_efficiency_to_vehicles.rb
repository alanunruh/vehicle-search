class AddFuelEfficiencyToVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :fuel_efficiency, :decimal
  end
end
