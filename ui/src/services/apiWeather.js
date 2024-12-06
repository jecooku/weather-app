const API_URL = 'http://localhost:3000/api/v1/weather/forecast?address';
const ADDRESS_URL = 'http://localhost:3000/api/v1/address?input';

export async function getWeather(address) {
  let encodedValue = encodeURIComponent(address);
  const res = await fetch(`${API_URL}=${encodedValue}`);

  if (!res.ok) throw Error('Failed getting weather data');

  const { data } = await res.json();
  return { weather: JSON.parse(data.data), cache: JSON.parse(data.cached) };
}

export async function getAddressSuggestion(query) {
  let encodedValue = encodeURIComponent(query);
  const res = await fetch(`${ADDRESS_URL}=${encodedValue}`);

  if (!res.ok) throw Error('Failed getting address data');

  const { data } = await res.json();

  return { suggestion: JSON.parse(data.data), cache: JSON.parse(data.cached) };
}
