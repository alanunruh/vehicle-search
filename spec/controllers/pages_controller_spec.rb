require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  context 'when requesting the homepage' do
    it 'returns a status of 200 ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
