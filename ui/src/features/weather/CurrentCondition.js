import moment from 'moment';
import { thermometerIcon } from './Icons';

function CurrentCondition({ weather, children, totalItems }) {
  const widthPercentage = totalItems <= 6 ? 100 / totalItems : 25; // Dynamically calculate width
  return (
    <div
      className="flex border-spacing-px flex-col items-center justify-between space-x-5 p-4"
      style={{ flex: `1 0 ${widthPercentage}%` }}
    >
      <div
        className="w-55 rounded-md border-2 border-solid bg-sky-50 p-4 md:w-[186px]"
        style={{ flex: 1 }}
      >
        <div className="border-b-2">{children}</div>
        {weather.time && (
          <div className="">{moment(weather.time).format('h:mm a')}</div>
        )}
        <div className="flex flex-col items-center">
          <img
            src={weather.condition.icon}
            alt={'weather conditions: ' + weather.condition.text}
          ></img>
          <div className="flex flex-row items-center justify-center">
            {thermometerIcon} {weather.temp_c} &deg;C
          </div>
          <div>({weather.temp_f}) F</div>
          <div>Sensation</div>
          <span className="flex items-center">
            {weather.feelslike_c} &deg;C
          </span>
          <div>({weather.feelslike_f} F)</div>
        </div>
      </div>
    </div>
  );
}

export default CurrentCondition;
