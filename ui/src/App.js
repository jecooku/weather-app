import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import './App.css';
import Weather, { loader as weatherLoader } from './features/weather/Weather';
import NotFound from './features/weather/Weather';
import AppLayout from './features/weather/AppLayout';
import Welcome from './features/weather/Welcome';

const router = createBrowserRouter([
  {
    element: <AppLayout />,
    children: [
      { path: '/', element: <Welcome /> },
      {
        path: '/weather/:address?',
        element: <Weather />,
        loader: weatherLoader,
      },
      { path: '*', element: <NotFound /> },
    ],
  },
]);

function App() {
  return <RouterProvider router={router} />;
}

export default App;
