require 'rails_helper'

describe HttpClients::WeatherClient do
  describe '#get_weather_by_address' do
    before do
      Rails.cache.clear
      @weather = {
        "location": {
          "name": "Montreal",
          "region": "",
          "country": "Canada",
          "lat": 45.5015,
          "lon": -73.5702,
          "tz_id": "America/Toronto",
          "localtime_epoch": 1733160995,
          "localtime": "2024-12-02 12:36"
        }
      }
    end

    it 'gets weather by address' do
      stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=12345&q=Montreal,%20QC").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'api.weatherapi.com',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: @weather.to_json, headers: {})

      response = HttpClients::WeatherClient.get_weather_by_address('Montreal, QC')

      expect(response.code).to eq('200')
      expect(JSON.parse(response.body)).to eq(@weather.as_json)
    end

    describe 'error handling' do
      it 'it raises a BadRequest error if it gets a 400 http code' do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=12345&q=Montreal,%20QC").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 400, body: @weather.to_json, headers: {})

        expect { HttpClients::WeatherClient.get_weather_by_address('Montreal, QC') }.to raise_error(HttpClients::WeatherClient::BadRequestError)
      end

      it 'it raises an ApiKeyError error if it gets a 401 http code' do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=12345&q=Montreal,%20QC").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 401, body: @weather.to_json, headers: {})

        expect { HttpClients::WeatherClient.get_weather_by_address('Montreal, QC') }.to raise_error(HttpClients::WeatherClient::ApiKeyError)
      end

      it 'it raises an AccessTokenExpiredError error if it gets a 403 http code' do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=12345&q=Montreal,%20QC").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 403, body: @weather.to_json, headers: {})

        expect { HttpClients::WeatherClient.get_weather_by_address('Montreal, QC') }.to raise_error(HttpClients::WeatherClient::AccessTokenExpiredError)
      end

      it 'it raises an WeatherClientError error if it gets another code' do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=12345&q=Montreal,%20QC").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 500, body: @weather.to_json, headers: {})

        expect { HttpClients::WeatherClient.get_weather_by_address('Montreal, QC') }.to raise_error(HttpClients::WeatherClient::HTTPClientError)
      end
    end
  end
end