require 'geohash_int'

class GeoHash
  attr_reader :latitude, :longitude, :value

  STEPS = 10

  # Initializes the GeoHash object
  # @param [Object] latitude of the coordinate
  # @param [Object] longitude  of the coordinate
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @value = nil
  end

  # Encodes a pair of values (latitude, longitude) into a hash value
  # @return [Object] a hash value
  def value
    @value ||= GeohashInt.encode(latitude.to_f, longitude.to_f, STEPS)
  end

  # Decodes a hash value into a latitude/longitude value
  # @param [Object] value os a hash
  # @return [Object] a latitude and longitude pair
  def self.from_geo_hash(value)
    GeohashInt.decode(value, STEPS)
  end
end