class RouteScraper

  def create_routes
    Rails.logger.info("--- scraping route list")
    route_hashes.collect do |v|
      route = Route.find_or_initialize_by(tag: v['tag'])
      route.update_attributes(v)
      route
    end
  end

  private

  def response
    unless @response
      uri = URI("http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=sf-muni")
      xml = Net::HTTP.get(uri)
      @response = Hash.from_xml(xml)
    end
    @response
  end

  def route_hashes
    Array.wrap(response['body']['route'])
  end

end
