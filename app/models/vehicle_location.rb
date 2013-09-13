class VehicleLocation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :location, type: Array
  field :lat, type: Float
  field :lon, type: Float

  index({ location: "2d" }, { min: -180, max: 180 })
  index({ location: "2dsphere" }, { min: -180, max: 180 })

  set_callback(:validation, :before) do |document|
    document.location = [document.lon.to_f, document.lat.to_f]
  end

  def stopped?
    speedKmHr.to_i == 0
  end

  def self.at_church_and_duboce_coord
    where(speedKmHr: '0', routeTag: "N", leadingVehicleId: nil).
      geo_near([-122.42941, 37.7694699]).max_distance(100).spherical
  end
end
