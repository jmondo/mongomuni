class VehicleLocation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :location, type: Array
  field :lat, type: Float
  field :lon, type: Float

  index({ location: "2d" }, { min: -180, max: 180 })
  index({ location: "2dsphere" }, { min: -180, max: 180 })

  set_callback(:validation, :before) do |document|
    document.location = [document.lat.to_f, document.lon.to_f]
  end
  end
end
