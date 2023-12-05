import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

export default function Home() {
  const [currentUser, setCurrentUser] = useState({});

  useEffect(() => {
    const url = '/';
    fetch(url)
      .then((response) => response.json())
      .then((response) => setCurrentUser(response));
  }, []);

  return (
    <div className="container d-flex flex-column align-items-center justify-content-center">
      <div className="d-flex align-items-center justify-content-center">
        <div className="p-5 mb-4 bg-body-tertiary rounded-3">
          <h1 className="display-6 ms-2">{`Welcome${currentUser.name ? `, ${currentUser.name}` : ''}!`}</h1>
          <div className="container-fluid py-5">
            <h1 className="display-4">Ilium Public Library</h1>
            <p className="lead">
              A book loan system that allows library members to reserve and schedule a pickup time.
            </p>
            <hr className="my-4" />
            {currentUser.role === 'library_clerk'
              ? (
                <Link
                  to="/books/search"
                  className="btn btn-outline-secondary"
                  role="button"
                >
                  Search & Reserve Books
                </Link>
              )
              : (
                <Link
                  to="/books/search"
                  className="btn btn-outline-secondary"
                  role="button"
                >
                  Search & Reserve Books
                </Link>
              )}
          </div>
        </div>
      </div>
    </div>
  );
}
