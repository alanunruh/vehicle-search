require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it { should validate_presence_of(:vin) }
  it { should validate_presence_of(:make) }
  it { should validate_presence_of(:model) }
  it { should validate_presence_of(:year) }
end
