import Form from './Form';

function Header() {
  return (
    <header className="border-b border-stone-200 bg-sky-500 px-4 py-3 uppercase tracking-widest">
      <p>Weather App</p>
      <Form />
    </header>
  );
}

export default Header;
