# a class just for recording when the last scrape was (because the api needs to know)
class VehicleLocationScrape
  include Mongoid::Document

  field :time, type: DateTime
  field :routeTag, type: String
end
