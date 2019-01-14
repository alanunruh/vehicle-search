FactoryBot.define do
  factory :vehicle do
    make { Faker::Vehicle.unique.make }
    model { Faker::Vehicle.unique.model }
    year { Faker::Vehicle.unique.year }
    vin { Faker::Vehicle.unique.vin }
    fuel_efficiency { nil }
  end
end
