require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe 'VehicleFuelEfficiencyWorker' do
  context 'when the vehicle fuel efficiency worker is scheduled' do
    it 'should queue a job' do
      VehicleFuelEfficiencyWorker.perform_async
      expect(VehicleFuelEfficiencyWorker.jobs.count).to eq(1)
    end

    it 'should be in the default queue' do
      expect(VehicleFuelEfficiencyWorker.queue).to eq('default')
    end

    it 'should respond to perform' do
      expect(VehicleFuelEfficiencyWorker.new).to respond_to(:perform)
    end
  end
end
