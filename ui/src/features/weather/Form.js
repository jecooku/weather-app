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
      <div className="flex items-center justify-center gap-10">
        <div>
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
            className="border-2 border-solid border-stone-500 bg-yellow-100 px-4 py-2 text-sm placeholder:stroke-stone-400 focus:outline-none focus:ring focus:ring-yellow-500 sm:w-[350px]"
          />
          <div className="absolute">
            {suggestions &&
              suggestions.map((prediction) => (
                <div
                  className="cursor-pointer border-b-2 border-l-2 border-r-2 border-solid border-stone-500 bg-yellow-100 px-4 py-2 text-sm lowercase placeholder:stroke-stone-400 focus:outline-none focus:ring focus:ring-yellow-500 sm:w-[350px]"
                  key={prediction.id}
                  onClick={(e) => handleSelect(prediction)}
                >
                  {prediction.place_name}
                </div>
              ))}
          </div>
        </div>
        <div>
          <button className="inline-block rounded-full bg-yellow-400 px-4 py-3 font-semibold uppercase tracking-wide text-stone-800 transition-colors duration-300 hover:bg-yellow-300">
            Get Weather
          </button>
        </div>
      </div>
    </form>
  );
}
