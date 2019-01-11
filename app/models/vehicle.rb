class Vehicle < ApplicationRecord
  validates :vin, :make, :model, :year, presence: true
end
