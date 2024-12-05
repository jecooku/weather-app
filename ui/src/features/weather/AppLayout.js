import { Outlet, useNavigation } from 'react-router-dom';
import Header from './Header';
import Loader from '../../components/Loader';

function AppLayout() {
  const navigation = useNavigation();
  const isLoading = navigation.state === 'loading';

  return (
    <div className="App" style={{ height: 100 }}>
      {isLoading && <Loader />}
      <Header />
      <main className="bg-sky-100 tracking-wide">
        <h1 className="py-8 text-center text-xl font-semibold">
          Weather Information for a given location
        </h1>
        <Outlet />
      </main>
    </div>
  );
}

export default AppLayout;
