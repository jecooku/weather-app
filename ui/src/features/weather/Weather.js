import React from 'react';
import { getWeather } from '../../services/apiWeather';
import { useLoaderData } from 'react-router-dom';
import CurrentCondition from './CurrentCondition';
import Hourly from './Hourly';
import Location from './Location';
import Forecast from './Forecast';

export async function loader({ params }) {
  const { weather, cache } = await getWeather(params.address);
  return { weather, cache };
}

function Weather() {
  const { weather, cache } = useLoaderData();

  console.log(cache);

  return (
    <section className="">
      {weather.current && (
        <div className="font-semibold">
          <div className={cache ? 'mb-4 bg-green-500' : ''}>
            {cache ? 'Cached' : ''}
          </div>
          <div className="m-auto grid w-1/2 grid-cols-1 md:grid-cols-3">
            <Location weather={weather} />
            <CurrentCondition weather={weather.current}>
              Current conditions
            </CurrentCondition>
            <Forecast weather={weather} />
          </div>

          <Hourly weather={weather} />
        </div>
      )}
    </section>
  );
}

export default Weather;
