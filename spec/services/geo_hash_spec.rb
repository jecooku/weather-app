require 'rails_helper'

describe GeoHash do

  describe '#initialize' do
    it 'should create a new GeoHash object' do
      GeoHash.new('17.0000', '85.0000').should be_an_instance_of GeoHash
    end

    it 'should create a new hash key' do
      expect(GeoHash.new('17.0000', '85.0000').value).not_to be_nil
    end

    it 'should return decoded latitude maxima and minima when given a key' do
      key = GeoHash.new('17.0000', '85.0000').value
      result = GeoHash.from_geo_hash(key)
      expect(17.00).to be_between(result.min_latitude, result.max_latitude)
    end

    it 'should return decoded longitude maxima and minima when given a key' do
      key = GeoHash.new(17.00, 80.00).value
      result = GeoHash.from_geo_hash(key)
      expect(80.00).to be_between(result.min_longitude, result.max_longitude)
    end
  end
end