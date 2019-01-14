require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  context 'when requesting the homepage' do
    subject do
      get :index
    end

    it 'returns a status of 200 ok' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when submitting a new vehicle vin' do
    let(:vehicle_vin_lookup_double) do
      double(VehicleVINLookupService, vin: 'VDJHSDIFH54389', make: 'Subaru', model: 'Outback')
    end

    before(:each) do
      allow_any_instance_of(VehicleVINLookupService).to receive(:perform).and_return(vehicle_vin_lookup_double)
    end

    subject do
      post :create,
           format: :js,
           params: {
             vehicle: {
               vin: 'VDJHSDIFH54389'
             }
           }
    end

    it 'returns a status of 302 found' do
      subject
      expect(response).to have_http_status(:found)
    end

    it 'responds with a success flash message' do
      subject
      expect(flash[:success]).to match('Vehicle successfully saved')
    end

    it 'redirects to the home page' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when submitting an existing vehicle vin' do
    let!(:vehicle) { create(:vehicle) }

    subject do
      post :create,
           format: :js,
           params: {
             vehicle: {
               vin: vehicle.vin
             }
           }
    end

    it 'returns a status of 302 found' do
      subject
      expect(response).to have_http_status(:found)
    end

    it 'responds with a success flash message' do
      subject
      expect(flash[:error]).to match('Vehicle already exists')
    end

    it 'redirects to the home page' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
