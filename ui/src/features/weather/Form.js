import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import useDebounce from '../../hooks/useDebounce';
import { getAddressSuggestion } from '../../services/apiWeather';

export default function Form() {
  const [address, setAddress] = useState('');
  const [suggestions, setSuggestions] = useState([]);
  const [coords, setCoords] = useState('');
  const navigate = useNavigate();
  const debouncedSearch = useDebounce(address, 200);
  const [selected, setSelected] = useState(false);

  function handleSubmit(e) {
    e.preventDefault();
    if (!coords || !address) return;
    navigate(`/weather/${coords}`);
    setAddress('');
  }

  function handleSelect(text) {
    console.log(text);
    setAddress(text.place_name);
    setCoords(extractCoords(text.center));
    setSuggestions([]);
    setSelected(true);
  }

  function extractCoords(info) {
    return `${info[1]},${info[0]}`;
  }

  useEffect(() => {
    (async () => {
      if (!selected && debouncedSearch.length > 2) {
        try {
          const data = await getAddressSuggestion(debouncedSearch);
          setSuggestions(data.suggestion.features);
        } catch (error) {
          console.error('Error while getting address suggestions: ', error);
          setSuggestions([]);
        }
      } else {
        setSuggestions([]);
      }
    })();
    setSelected(false);
  }, [debouncedSearch]);

  return (
    <form onSubmit={handleSubmit}>
      <label>Please enter an address</label>
      <div className="flex flex-col items-center justify-center gap-10 py-4 md:flex-row">
        <div className="items-start">
          <input
            type="text"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            placeholder="type and select an address..."
            onBlur={() => {
              setTimeout(() => {
                setSuggestions([]);
              }, 100);
            }}
            className="border-2 border-solid border-stone-500 bg-sky-100 px-4 py-2 text-sm placeholder:stroke-stone-400 focus:outline-none focus:ring focus:ring-sky-500 sm:w-[350px]"
          />
          <div className="absolute">
            {suggestions &&
              suggestions.map((prediction) => (
                <div
                  className="w-[192px] cursor-pointer border-b-2 border-l-2 border-r-2 border-solid border-stone-500 bg-sky-100 px-4 py-2 text-sm placeholder:stroke-stone-400 focus:outline-none focus:ring focus:ring-sky-500 sm:w-[350px]"
                  key={prediction.id}
                  onClick={() => {
                    handleSelect(prediction);
                  }}
                >
                  {prediction.place_name}
                </div>
              ))}
          </div>
        </div>
        <div>
          <button className="inline-block rounded-full bg-sky-300 px-4 py-3 font-semibold uppercase tracking-wide text-stone-800 transition-colors duration-300 hover:bg-sky-200">
            Get Weather
          </button>
        </div>
      </div>
    </form>
  );
}
