import CurrentCondition from './CurrentCondition';
import moment from 'moment';

function Hourly({ weather }) {
  function nextHours(weather) {
    console.log(weather);
    return weather.forecast.forecastday[0].hour.filter((hour) =>
      moment(hour.time).isAfter(weather.location.localtime),
    );
  }

  return (
    <div className="">
      <div className="">Hourly Forecast</div>
      <div className="m-auto flex flex-wrap items-center justify-center md:w-[1200px]">
        {nextHours(weather).map((dailyForecast) => (
          <CurrentCondition weather={dailyForecast} key={dailyForecast.time}>
            Hour
          </CurrentCondition>
        ))}
      </div>
    </div>
  );
}

export default Hourly;
