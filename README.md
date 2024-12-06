# README

## Weather App

The following app is a web based weather forecasting service. It returns the weather information of location selected
from the text input dropdown.

**Instructions**

To run the App:
1. run `docker-compose build`
2. run `docker-compose up` to start the app
3. run `docker-compose down` to stop the container
4. run `docker exec -it <container-name> /bin/bash` to enter the container's console
5. To access the app, go to http://localhost:3001/

To run tests:
1. docker-compose -f docker-compose.test.yml build
2. docker-compose -f docker-compose.test.yml up

**User flow**

1. User enters the app and is greeted by a welcome screen
2. User begins to enter an address
3. The App shows suggestion which grow in accuracy as the user enters more details
4. The user selects an item from the selection dropdown
5. The users click on `GET WEATHER`
6. The app displays the weather information for the selected address
7. If the data is cached, the app will display a visual indicator (as required - see demo)

N.B. Once an address is visited for the first time, the result is cached as per assignment requirements.

**Used tools and frameworks**
- Ruby on Rails (API)
- React (IU)
- Redis (Caching)
- Others
  - Tailwind CSS
  - React router dom


<summary>API details

1. **Address suggestions endpoint**
   - **GET**: `/api/v1/address/{input}` 
   - **Description**: Provides address suggestions given a partial address string or a postal code
   - **Parameters**:
     - `input`
       - Required: true
       - Type: string

2. **Weather forecast service endpoint**
    - **GET**: `/api/v1/weather/forecast/{coords}`
    - **Description**: Provides the weather information of a location given in the form of latitude, longitude. It
    includes information such as current weather conditions, daily minimum and maximum temperatures, and hourly forecast
    for the current day of the location.
    - **Parameters**:
        - `address`
            - Required: true
            - Type: string
            - Format (`latitude, longitude`): `45.50283,-73.5728`
</summary>

**Assignment requirements**

   - Must be done in Ruby on Rails &check;
   - Accept an address as input &check;
   - Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast) &check;
   - Display the requested forecast details to the user &check;
   - Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache. &check;

**Caching implementation**

Location caching is done using the [GeoHash](https://en.wikipedia.org/wiki/Geohash) hash algorithm,
which encodes a geographic location into a short string of letters and digits. For exact latitude and longitude translations 
Geohash is a spatial index of base 4. Furthermore, the accuracy of the hash can be fine tuned by modifying its number of steps. I.e.
The more steps, the more precise the decoded coordinate will be. On the other hand, caching using pure postal codes was discarded due to the differences 
in granularity of the various postal codes worldwide, which could make the memory requirements too great and hard to predict in cases where postal codes are
too granular.

For address Hashing, the SHA256 algorithm was chosen as it is more resistant to collisions than other alternatives, like MD5.

**Assumptions**

The following items are out of the scope of this assignment:

   - Session tracking. I.E. the API is open to all users
   - Deployment to production
   - Authorization
   - Authentication
   - UI testing
   - Throttling and rate limiting
   - UI data types
   - Advanced logging
   - Error and performance monitoring
