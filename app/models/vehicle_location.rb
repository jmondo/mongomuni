# this is actually prediction data now

class VehicleLocation
  include Mongoid::Document

  field :location, type: Array
  field :lat, type: Float
  field :lon, type: Float

  field :routeTag, type: String
  field :vehicleId, type: String
  field :dirTag, type: String
  field :heading, type: String
  field :predictable, type: Boolean
  field :secsSinceReport, type: Integer
  field :speedKmHr, type: Integer
  field :leadingVehicleId, type: String

  include Mongoid::Timestamps

  acts_as_gmappable :position => :location_reverse, :process_geocoding => false

  index({ location: "2d" }, { min: -180, max: 180 })
  index({ location: "2dsphere" }, { min: -180, max: 180 })

  default_scope where(predictable: true)

  set_callback(:validation, :before) do |document|
    document.location = [document.lon.to_f, document.lat.to_f]
  end

  def stopped?
    speedKmHr.to_i == 0
  end

  def self.at_church_and_duboce_coord
    where(speedKmHr: '0', routeTag: "N").geo_near([-122.42984, 37.76949]).max_distance(0.00001).spherical
  end

  def location_reverse
    location.reverse
  end
end
