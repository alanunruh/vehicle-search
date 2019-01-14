class VehicleVINLookupService
  def initialize(vin)
    @vin = vin
  end

  def perform
    perform_request
    parse_data_and_save
    VehicleFuelEfficiencyWorker.perform_async(@vehicle.id, @fleetio_vehicle_id) if @vehicle.persisted?
  end

  private

  def perform_request
    url = Faraday.new url: 'https://secure.fleetio.com/api/v1/vehicles',
                      headers:
                      {
                        "Authorization": "Token token=#{ENV['FLEETIO_API_KEY']}",
                        "Account-Token": ENV['FLEETIO_ACCOUNT_TOKEN']
                      }
    @response = url.get "?q[vin_eq]=#{@vin}"
  end

  def parse_data_and_save
    vehicle_data = JSON.parse(@response.body)[0]
    @fleetio_vehicle_id = vehicle_data['id']
    @vehicle = Vehicle.create(vin: vehicle_data['vin'],
                              make: vehicle_data['make'],
                              model: vehicle_data['model'],
                              year: vehicle_data['year'])
  end
end
