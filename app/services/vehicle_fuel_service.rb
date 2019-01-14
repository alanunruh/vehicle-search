class VehicleFuelService
  def initialize(vehicle, fleetio_vehicle_id)
    @vehicle = vehicle
    @fleetio_vehicle_id = fleetio_vehicle_id
  end

  def perform
    perform_request
    parse_response
    calculate_fuel_efficiency
    update_vehicle
  end

  private

  def perform_request
    url = Faraday.new url: 'https://secure.fleetio.com/api/v1/fuel_entries',
                      headers:
                      {
                        "Authorization": "Token token=#{ENV['FLEETIO_API_KEY']}",
                        "Account-Token": ENV['FLEETIO_ACCOUNT_TOKEN']
                      }
    @response = url.get "?q[vehicle_id_eq]=#{@fleetio_vehicle_id}"
  end

  def parse_response
    @fuel_entries = JSON.parse(@response.body)
  end

  def calculate_fuel_efficiency
    @fuel_efficiency = (calculate_total_gallons / calculate_total_miles)
  end

  def calculate_total_gallons
    total_gallons = []
    @fuel_entries.each do |fuel_entry|
      total_gallons << fuel_entry['us_gallons'].to_f
    end
    total_gallons.sum
  end

  def calculate_total_miles
    total_miles = []
    @fuel_entries.each do |fuel_entry|
      total_miles << fuel_entry['usage_in_mi'].to_f
    end
    total_miles.sum
  end

  def update_vehicle
    @vehicle.update(fuel_efficiency: @fuel_efficiency)
  end
end
