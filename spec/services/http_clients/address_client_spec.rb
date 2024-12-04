require 'rails_helper'

describe HttpClients::AddressClient do
  describe '#get_weather_by_address' do
    before do
      Rails.cache.clear
      @address = {
        "type"=>"FeatureCollection",
        "query"=>["montreal"],
        "features"=>
          [{"id"=>"place.49604647",
            "type"=>"Feature",
            "place_type"=>["place"],
            "relevance"=>1,
            "properties"=>{"mapbox_id"=>"dXJuOm1ieHBsYzpBdlRvSnc", "wikidata"=>"Q340"},
            "text"=>"Montréal",
            "place_name"=>"Montréal, Quebec, Canada",
            "bbox"=>[-73.76371, 45.438927, -73.492772, 45.702316],
            "center"=>[-73.5728, 45.50283],
            "geometry"=>{"type"=>"Point", "coordinates"=>[-73.5728, 45.50283]},
            "context"=>[{"id"=>"region.9255", "mapbox_id"=>"dXJuOm1ieHBsYzpKQ2M", "wikidata"=>"Q176",
                         "short_code"=>"CA-QC", "text"=>"Quebec"}, {"id"=>"country.8743",
                                                                    "mapbox_id"=>"dXJuOm1ieHBsYzpJaWM",
                                                                    "wikidata"=>"Q16", "short_code"=>"ca",
                                                                    "text"=>"Canada"}]}]}
    end

    it 'gets weather by address' do
      stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'api.mapbox.com',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: @address.to_json, headers: {})

      response = HttpClients::AddressClient.get_address_suggestion('Montreal')

      expect(response.code).to eq('200')
      expect(JSON.parse(response.body)).to eq(@address.as_json)
    end

    describe 'error handling' do
      it 'it raises a BadRequest error if it gets a 400 http code' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 400, body: @address.to_json, headers: {})

        expect { HttpClients::AddressClient.get_address_suggestion('Montreal') }.to raise_error(HttpClients::AddressClient::BadRequestError)
      end

      it 'it raises an ApiKeyError error if it gets a 401 http code' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 401, body: @address.to_json, headers: {})

        expect { HttpClients::AddressClient.get_address_suggestion('Montreal') }.to raise_error(HttpClients::AddressClient::ApiKeyError)
      end

      it 'it raises an AccessTokenExpiredError error if it gets a 403 http code' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 403, body: @address.to_json, headers: {})

        expect { HttpClients::AddressClient.get_address_suggestion('Montreal') }.to raise_error(HttpClients::AddressClient::AccessTokenExpiredError)
      end

      it 'it raises an WeatherClientError error if it gets another code' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 500, body: @address.to_json, headers: {})

        expect { HttpClients::AddressClient.get_address_suggestion('Montreal') }.to raise_error(HttpClients::AddressClient::HTTPClientError)
      end

      it 'it retries if rate limit is reached' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=abcde").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 429, body: @address.to_json, headers: {})

        error_message = "Rate limit reached after #{HttpClients::AddressClient::RETRIES_LIMIT} tries"
        expect { HttpClients::AddressClient.get_address_suggestion('Montreal') }.to raise_error(HttpClients::AddressClient::HTTPClientError, error_message)
      end
    end
  end
end