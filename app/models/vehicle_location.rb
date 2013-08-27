class VehicleLocation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :location, type: Array
  index({ location: "2d" }, { min: -180, max: 180 })

  set_callback(:validation, :before) do |document|
    document.location = [document.lat, document.lon]
  end
end
