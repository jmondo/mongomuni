class VehicleLocationScrapesController < ApplicationController
  def create
    route_ids = params[:route_ids]
    route_ids.each do |route|
      VehicleLocationScraper.new(route).create_vehicle_locations
    end
  end
end
