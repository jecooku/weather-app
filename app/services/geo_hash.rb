require 'geohash_int'

class GeoHash
  attr_reader :latitude, :longitude, :value

  STEPS = 10

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @value = nil
  end

  def value
    @value ||= GeohashInt.encode(latitude.to_f, longitude.to_f, STEPS)
  end

  def self.from_geo_hash(value)
    GeohashInt.decode(value, STEPS)
  end
end