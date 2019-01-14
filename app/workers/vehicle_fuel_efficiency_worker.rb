class VehicleFuelEfficiencyWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(vehicle_id, fleetio_vehicle_id)
    vehicle = Vehicle.find(vehicle_id)
    VehicleFuelService.new(vehicle, fleetio_vehicle_id).perform
  end
end
