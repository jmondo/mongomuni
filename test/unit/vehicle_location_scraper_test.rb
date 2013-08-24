require 'test_helper'
require 'net/http'


class VehicleLocationScraperTest < ActiveSupport::TestCase
  test "it returns an empty array if response has no vehicle tag" do
    VCR.use_cassette('no buses', record: :once) do
      assert_equal [], VehicleLocationScraper.new('83x').create_vehicle_locations
    end
  end

  test "it returns an array of vehicle location objects" do
    VCR.use_cassette('many buses', record: :once) do
      locations = VehicleLocationScraper.new('22').create_vehicle_locations
      assert Array === locations, 'should be an array'
      assert VehicleLocation === locations.first, 'should be a vehicle location'
      assert locations.first.persisted?, 'should be saved'
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
end
