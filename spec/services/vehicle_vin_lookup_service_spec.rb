require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe VehicleVINLookupService do
  context 'when looking up a vehicle in Fleetio' do
    let!(:vin) { Faker::Vehicle.unique.vin }
    let!(:vehicle) { create(:vehicle, vin: vin) }

    before do
      vehicle_response = [{
        vin: vehicle.vin,
        make: vehicle.make,
        model: vehicle.model,
        year: vehicle.year
      }].to_json

      stub_request(:get, "https://secure.fleetio.com/api/v1/vehicles?q%5Bvin_eq%5D=#{vin}")
        .with(
          headers: {
            'Accept': '*/*',
            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            "Account-Token": ENV['FLEETIO_ACCOUNT_TOKEN'],
            "Authorization": "Token token=#{ENV['FLEETIO_API_KEY']}",
            'User-Agent': 'Faraday v0.15.4'
          }
        )
        .to_return(status: 200, body: vehicle_response, headers: {})
    end

    it 'should save the data as a vehicle' do
      client = VehicleVINLookupService.new(vin)
      response = client.perform
      expect(response).to eq response
    end

    it 'should queue a job after a vehicle is saved' do
      expect(VehicleFuelEfficiencyWorker.jobs.count).to eq(1)
    end
  end
end
