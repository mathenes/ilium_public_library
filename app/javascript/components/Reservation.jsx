import React, { useState, useEffect } from 'react';
import {
  useNavigate, useParams, useSearchParams,
} from 'react-router-dom';
import GoBack from './utils/GoBack';

export default function ReservationSearch() {
  const params = useParams();
  const navigate = useNavigate();
  // eslint-disable-next-line no-unused-vars
  const [searchParams, setSearchParams] = useSearchParams();
  const [reservation, setReservation] = useState({});
  const [success, setSuccess] = useState(false);
  const [errors, setErrors] = useState([]);

  useEffect(() => {
    const url = `/reservations/${params.id}`;
    fetch(url)
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error('Network response was not ok.');
      })
      .then((response) => setReservation(response))
      .catch(() => navigate('/reservations'));
  }, [params.id]);

  const performAction = (action) => {
    const url = `/reservations/${reservation.reservation_token}`;
    const token = document.querySelector('meta[name="csrf-token"]').content;

    const body = {
      reservation: { action },
    };

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    }).then(async (response) => {
      if (response.ok) {
        return response.json();
      }
      const error = await response.json();
      throw new Error(error.msg);
    }).then((response) => {
      setErrors([]);
      setSuccess(true);
      setReservation(response);
    }).catch((err) => setErrors([err.message]));
  };

  const backUrl = () => {
    const url = '/reservations';

    return `${url}?reservation_token=${reservation.reservation_token}`;
  };

  return (
    reservation.id
      && (
        <div className="col-lg-8 mx-auto p-4 py-md-5">
          <div className="mb-3">
            <GoBack backUrl={backUrl()} />
          </div>
          <main>
            <div>
              <h2 className="text-body-emphasis">Reservation Info</h2>
              <hr className="col-4 col-md-6 mb-2" />
              <p className="lead">
                <code>Reservation:</code>
                {' '}
                {reservation.reservation_token}
              </p>
              <p className="lead">
                <code>State:</code>
                {' '}
                {reservation.state}
              </p>
              <p className="lead">
                <code>Pick Up Time:</code>
                {' '}
                {reservation.pick_up_time}
              </p>
            </div>
            <div>
              <h2 className="text-body-emphasis mt-4">Member Info</h2>
              <hr className="col-4 col-md-6 mb-2" />
              <p className="lead">
                <code>Name:</code>
                {' '}
                {reservation.user.name}
              </p>
              <p className="lead">
                <code>Email:</code>
                {' '}
                {reservation.user.email}
              </p>
            </div>
            <div>
              <h2 className="text-body-emphasis mt-4">Book Info</h2>
              <hr className="col-4 col-md-6 mb-2" />
              <p className="lead">
                <code>Name:</code>
                {' '}
                {reservation.book.title}
              </p>
              <p className="lead">
                <code>Email:</code>
                {' '}
                {reservation.book.author}
              </p>
            </div>

            {reservation.state === 'reserved'
              && (
                <>
                  <button type="button" className="btn btn-success mt-3 me-3" onClick={() => performAction('pick_up_book')}>Pick Up Book</button>
                  <button type="button" className="btn btn-danger mt-3" onClick={() => performAction('cancel')}>Cancel</button>
                </>
              )}
            {reservation.state === 'lent'
              && <button type="button" className="btn btn-success mt-3 me" onClick={() => performAction('deliver_book')}>Deliver Book</button>}

            {errors.length > 0 && errors.map((error) => (
              <div key={error} className="alert alert-danger show mt-3" role="alert">
                {error}
              </div>
            ))}

            {success
              && (
              <div className="alert alert-success alert-dismissible fade show mt-3" role="alert">
                Reservation updated with success!
                <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close" />
              </div>
              )}
          </main>
        </div>
      )
  );
}
