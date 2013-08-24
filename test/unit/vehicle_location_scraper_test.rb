require 'test_helper'
require 'net/http'


class VehicleLocationScraperTest < ActiveSupport::TestCase
  test "it returns an empty array if response has no vehicle tag" do
    VCR.use_cassette('no buses', record: :once) do
      assert_equal [], VehicleLocationScraper.new('83x').vehicle_locations
    end
  end

  test "it returns an array of vehicle location objects" do
    VCR.use_cassette('many buses', record: :once) do
      response = VehicleLocationScraper.new('22').vehicle_locations
      assert Array === response, 'should be an array'
      assert VehicleLocation === response.first, 'should be a vehicle location'
    end
  end
end
