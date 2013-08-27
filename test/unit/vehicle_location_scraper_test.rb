require 'test_helper'
require 'net/http'


class VehicleLocationScraperTest < ActiveSupport::TestCase
  test "it returns an empty array if response has no vehicle tag" do
    VCR.use_cassette('no buses', record: :once) do
      assert_equal [], VehicleLocationScraper.new('83x').create_vehicle_locations
    end
  end

  test "it returns an array of vehicle location objects with many buses" do
    VCR.use_cassette('many buses', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      assert Array === locations, 'should be an array'
      assert VehicleLocation === locations.first, 'should be a vehicle location'
    end
  end

  test "it returns an array of vehicle location objects with one bus" do
    VCR.use_cassette('one bus', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      assert Array === locations, 'should be an array'
      assert VehicleLocation === locations.first, 'should be a vehicle location'
    end
  end

  test "it saves vehicle location objects" do
    VCR.use_cassette('many buses', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      assert locations.first.persisted?, 'should be saved'
    end
  end

  test "it sets the vehicleId on the object" do
    VCR.use_cassette('many buses', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      assert locations.first.vehicleId, 'should have vehicle id'
    end
  end

  test "it sets the location on the object as an array of lat lon" do
    VCR.use_cassette('many buses', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      loc = locations.first
      assert_equal [loc.lat, loc.lon], loc.location
    end
  end

  test "it creates a vehicle location scrape with the time from the response" do
    VCR.use_cassette('many buses', record: :once) do
      VehicleLocationScraper.new('22').create_vehicle_locations
      assert VehicleLocationScrape.first.time
    end
  end

  test "it creates a vehicle location scrape with the route" do
    VCR.use_cassette('many buses', record: :once) do
      VehicleLocationScraper.new('22').create_vehicle_locations
      assert_equal '22', VehicleLocationScrape.last.routeId
    end
  end
end
