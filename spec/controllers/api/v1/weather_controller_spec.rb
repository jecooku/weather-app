require 'rails_helper'

RSpec.describe Api::V1::WeatherController, type: :controller do
  describe "GET forecast" do
    before do
      Rails.cache.clear
      @address = {
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

      @data = { "success?": true, data: @address, cached: false }
    end

    context 'Good responses' do
      it "Returns external data if first call is made" do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=12345&q=45.50283,-73.5728").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: "", headers: {})

        get :forecast, params: { address: '45.50283,-73.5728' }

        expect(response).to have_http_status(:ok)
      end

      it "caches response" do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=12345&q=45.50283,-73.5728").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: "", headers: {})

        get :forecast, params: { address: '45.50283,-73.5728' }

        expect(Rails.cache.instance_variable_get(:@data).key?(::GeoHash.new(45.50283, -73.5728).value.to_s)).to be true
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Errors' do
      it 'handles missing param' do
        expect { get :forecast }.to raise_error ActionController::ParameterMissing
      end

      it 'handles errors' do
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=12345&q=45.50283,-73.5728").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.weatherapi.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 400, body: "", headers: {})

        expect { get :forecast, params: { address: '45.50283,-73.5728'} }.to raise_error(HttpClients::WeatherClient::BadRequestError)
      end
    end
  end
end