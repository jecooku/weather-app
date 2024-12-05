function Location({ weather }) {
  return (
    <div className="flex border-spacing-px flex-col items-center justify-between space-x-5 p-4">
      <div
        className="rounded-md border-2 border-solid bg-yellow-100 p-4"
        style={{ flex: 1 }}
      >
        <div className="border-b-2">Location</div>
        <div className="pt-3">
          <table className="table-auto border-spacing-3">
            <tbody>
              <tr>
                <td>Location</td>
                <td>{weather.location.name}</td>
              </tr>
              <tr>
                <td>Country</td>
                <td>{weather.location.country}</td>
              </tr>
              <tr>
                <td>Latitude</td>
                <td>{weather.location.lat}</td>
              </tr>
              <tr>
                <td>Longitude</td>
                <td>{weather.location.lon}</td>
              </tr>
              <tr>
                <td>Sunrise</td>
                <td>{weather.forecast.forecastday[0].astro.sunrise}</td>
              </tr>
              <tr>
                <td>Sunset</td>
                <td>{weather.forecast.forecastday[0].astro.sunset}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default Location;
