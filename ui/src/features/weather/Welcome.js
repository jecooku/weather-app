function Welcome() {
  return (
    <div className="flex flex-col">
      <div className="bg-sky-50" style={{ flex: 1 }}></div>
      <h1>Welcome to the weather App!</h1>
      <p className="h-lvh">
        Please enter and select an address to see the weather in that location.
      </p>
    </div>
  );
}

export default Welcome;
