import { Link } from 'react-router-dom';

function NotFound() {
  return (
    <div>
      Page not found
      <Link to="/">Home</Link>;
    </div>
  );
}

export default NotFound;
