import { Outlet } from 'react-router-dom';
import Header from './Header';

function AppLayout() {
  return (
    <div className="App" style={{ height: 100 }}>
      <Header />
      <main className="bg-yellow-50 tracking-wide">
        <h1 className="my-8 text-center text-xl font-semibold">
          Weather Information for a given location
        </h1>
        <Outlet />
      </main>
    </div>
  );
}

export default AppLayout;
