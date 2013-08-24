require 'net/http'
require 'uri'

class VehicleLocationScraper < Struct.new(:route)
  def create_vehicle_locations
    Rails.logger.info("--- scraping vehicle locations for #{route} since #{last_scraped_at}")
    VehicleLocationScrape.create(
      time: response['body']['lastTime']['time'],
      routeId: route
    )
    vehicle_locations_hashes.collect do |v|
      v['vehicleId'] = v.delete('id')
      VehicleLocation.create(v)
    end
  end

  private

  def last_scraped_at
    VehicleLocationScrape.where(routeId: route).last.try(:time)
  end

  def response
    unless @response
      uri = URI("http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r=#{route}&t=#{last_scraped_at}")
      Rails.logger.info("--- at #{uri}")
      xml = Net::HTTP.get(uri)
      @response = Hash.from_xml(xml)
    end
    @response
  end

  def vehicle_locations_hashes
    Array.wrap(response['body']['vehicle'])
  end

end
