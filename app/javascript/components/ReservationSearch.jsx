import React, { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';

export default function ReservationSearch() {
  const navigate = useNavigate();
  // eslint-disable-next-line no-unused-vars
  const [searchParams, setSearchParams] = useSearchParams();
  const [reservationToken, setReservationToken] = useState(searchParams.get('reservation_token') || '');
  const [errors, setErrors] = useState([]);

  const search = () => {
    const baseUrl = '/reservations';
    const completeUrl = `${baseUrl}?reservation_token=${reservationToken}`;
    setErrors('');

    fetch(completeUrl, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(async (response) => {
        if (response.ok) {
          return response.json();
        }
        const error = await response.json();
        throw new Error(error.msg);
      })
      .then((res) => navigate(`/reservations/${res.reservation_token}`))
      .catch((err) => setErrors([err.message]));
  };

  return (
    <div className="col-lg-8 mx-auto p-4 py-md-5">
      <main>
        <h1 className="text-body-emphasis">Manage Book Reservation</h1>
        <p className="fs-5 col-md-8">Use the reservation number to find the reservation to set it lent or delivered.</p>
        <hr className="my-4" />

        <div className="mb-4">
          <div>
            <h2 className="text-body-emphasis">Reservation Number</h2>
            <div className="mb-3">
              <input type="text" className="form-control" value={reservationToken} onChange={(e) => setReservationToken(e.target.value)} />
            </div>

            <button type="button" className="btn btn-primary" onClick={search}>Search</button>

            {errors.length > 0 && errors.map((error) => (
              <div key={error} className="alert alert-danger show mt-3" role="alert">
                {error}
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
}
