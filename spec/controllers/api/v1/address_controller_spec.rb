require 'rails_helper'

RSpec.describe Api::V1::AddressController, type: :controller do
  describe "GET index" do
    before do
      Rails.cache.clear
      @address = {"type"=>"FeatureCollection",
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
      @data = { "success?": true, data: @address, cached: false }
    end

    context 'Good responses' do
      it "Returns external data if first call is made" do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: @data.to_json, headers: {})

        get :index, params: { input: 'Montreal'}

        expect(response).to have_http_status(:ok)
      end

      it "caches response" do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: "", headers: {})

        get :index, params: { input: 'Montreal'}

        expect(Rails.cache.instance_variable_get(:@data).key?(Digest::SHA256.hexdigest('Montreal'))).to be true
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Errors' do
      it 'handles missing param' do
        expect { get :index }.to raise_error ActionController::ParameterMissing
      end

      it 'handles 400 errors' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 400, body: "", headers: {})

        expect { get :index, params: { input: 'Montreal'} }.to raise_error HttpClients::AddressClient::BadRequestError
      end

      it 'handles 401 errors' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 401, body: "", headers: {})

        expect { get :index, params: { input: 'Montreal'} }.to raise_error HttpClients::AddressClient::ApiKeyError
      end

      it 'handles 403 errors' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 403, body: "", headers: {})

        expect { get :index, params: { input: 'Montreal'} }.to raise_error HttpClients::AddressClient::AccessTokenExpiredError
      end

      it 'handles 404 errors' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 404, body: "", headers: {})

        expect { get :index, params: { input: 'Montreal'} }.to raise_error HttpClients::AddressClient::NotFoundError
      end

      it 'handles other errors errors' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 500, body: "", headers: {})

        expect { get :index, params: { input: 'Montreal'} }.to raise_error HttpClients::AddressClient::HTTPClientError
      end

      it 'it retries if rate limit is reached' do
        stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Montreal.json?access_token=#{ENV['ADDRESS_API_TOKEN']}").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Host'=>'api.mapbox.com',
              'User-Agent'=>'Ruby'
            }).
          to_return(status: 429, body: @address.to_json, headers: {})

        error_message = "Rate limit reached after #{HttpClients::AddressClient::RETRIES_LIMIT} tries"
        expect { get :index, params: { input: 'Montreal'} }.to raise_error(HttpClients::AddressClient::HTTPClientError, error_message)
      end
    end
  end
end