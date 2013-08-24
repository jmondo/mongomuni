require 'net/http'
require 'uri'

class VehicleLocationScraper < Struct.new(:route)
  def vehicle_locations
    vehicle_locations_xml.collect do |v|
      VehicleLocation.create(v)
    end
  end

  private

  def response
    uri = URI("http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r=#{route}")
    xml = Net::HTTP.get(uri)
    Hash.from_xml(xml)
  end

  def vehicle_locations_xml
    Array(response['body']['vehicle'])
  end

end
