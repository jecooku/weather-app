import CurrentCondition from './CurrentCondition';
import moment from 'moment';

function Hourly({ weather }) {
  function nextHours(weather) {
    return weather.forecast.forecastday[0].hour.filter((hour) =>
      moment(hour.time).isAfter(weather.location.localtime),
    );
  }

  const hourlyData = nextHours(weather);

  return (
    <div className="">
      <div className="">Hourly Forecast</div>
      <div className="m-auto flex flex-wrap items-center justify-center md:w-[1200px]">
        {hourlyData.map((dailyForecast) => (
          <CurrentCondition
            weather={dailyForecast}
            key={dailyForecast.time}
            totalItems={hourlyData.length} // Pass the total count
          >
            Hour
          </CurrentCondition>
        ))}
      </div>
    </div>
  );
}

export default Hourly;
