import { highThermometerIcon, lowThermometerIcon } from './Icons';

function Forecast({ weather }) {
  return (
    <div className="flex border-spacing-px flex-col items-center justify-between space-x-5 p-4">
      <div
        className="rounded-md border-2 border-solid bg-yellow-100 p-4 px-[27px]"
        style={{ flex: 1 }}
      >
        <div className="border-b-2">Today's Forecast</div>
        <div className="flex flex-col items-center">
          <div className="pt-3">Minimum</div>
          <span className="flex items-center">
            {lowThermometerIcon} {weather.forecast.forecastday[0].day.mintemp_c}{' '}
            &deg;C
          </span>
          <div className="">
            ({weather.forecast.forecastday[0].day.mintemp_f} F)
          </div>
          <div className="">Maximum</div>
          <span className="flex items-center">
            {highThermometerIcon}
            {weather.forecast.forecastday[0].day.maxtemp_c} &deg;C
          </span>
          <div>({weather.forecast.forecastday[0].day.maxtemp_f} F)</div>
        </div>
      </div>
    </div>
  );
}

export default Forecast;
