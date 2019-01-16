require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe VehicleFuelService do
  context 'when looking up a vehicle in Fleetio' do
    let!(:vehicle) { create(:vehicle) }
    let!(:fleetio_vehicle_id) { 3 }

    before do
      fuel_entry_response = [
        { us_gallons: 12, usage_in_mi: 34 },
        { us_gallons: 3, usage_in_mi: 6 },
        { us_gallons: 34, usage_in_mi: 72 },
        { us_gallons: 5, usage_in_mi: 11 }
      ].to_json

      stub_request(:get, "https://secure.fleetio.com/api/v1/fuel_entries?q%5Bvehicle_id_eq%5D=#{fleetio_vehicle_id}")
        .with(
          headers: {
            'Accept': '*/*',
            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            "Account-Token": ENV['FLEETIO_ACCOUNT_TOKEN'],
            "Authorization": "Token token=#{ENV['FLEETIO_API_KEY']}",
            'User-Agent': 'Faraday v0.15.4'
          }
        )
        .to_return(status: 200, body: fuel_entry_response, headers: {})
    end

    it 'gather data and calculate the efficiency of the vehicle' do
      client = VehicleFuelService.new(vehicle, fleetio_vehicle_id)
      response = client.perform
      expect(response).to eq response
    end

    it 'should save the fuel efficiency to the vehicle' do
      client = VehicleFuelService.new(vehicle, fleetio_vehicle_id)
      client.perform
      vehicle.reload
      expect(vehicle.fuel_efficiency).to_not eq(nil)
    end
  end
end
