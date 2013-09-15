class VehicleLocationsController < ApplicationController
  def index
    # @json = VehicleLocation.at_church_and_duboce_coord.to_gmaps4rails
    locs = VehicleLocationScraper.new('J').create_vehicle_locations
    @json = locs.to_gmaps4rails
  end
end
