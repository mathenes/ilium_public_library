import React, { useState, useEffect } from 'react';
import {
  Link, useNavigate, useParams, useSearchParams,
} from 'react-router-dom';
import DatePicker from 'react-datepicker';
import moment from 'moment-timezone';

function Book() {
  const navigate = useNavigate();
  const params = useParams();
  // eslint-disable-next-line no-unused-vars
  const [searchParams, setSearchParams] = useSearchParams();
  const [book, setBook] = useState({});
  const [reservation, setReservation] = useState({});
  const [pickUpTime, setPickUpTime] = useState('');
  const [errors, setErrors] = useState([]);

  useEffect(() => {
    const url = `/books/${params.id}`;
    fetch(url)
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error('Network response was not ok.');
      })
      .then((response) => setBook(response))
      .catch(() => navigate('/search'));
  }, [params.id]);

  const reserve = () => {
    const convertedDateToServerTimezone = moment(pickUpTime).tz('Canada/Central', true);
    const url = `/books/${params.id}/reservations`;
    const token = document.querySelector('meta[name="csrf-token"]').content;

    const body = {
      reservation: {
        pick_up_time: convertedDateToServerTimezone,
      },
    };

    fetch(url, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    }).then(async (response) => {
      if (response.ok) {
        return response.json();
      }
      const text = await response.json();
      throw new Error(text.msg);
    }).then((response) => {
      setErrors([]);
      setReservation(response);
    }).catch((err) => setErrors([...errors, err.message]));
  };

  const backUrl = () => {
    const url = '/books/search';
    if (searchParams.get('type') && searchParams.get('query')) {
      return `${url}?${searchParams.toString()}`;
    }
    return url;
  };

  return (
    <div className="col-lg-8 mx-auto p-4 py-md-5">
      <div className="mb-3">
        <Link
          to={backUrl()}
          className="btn btn-secondary"
          role="button"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-arrow-return-left" viewBox="0 0 16 16">
            <path fillRule="evenodd" d="M14.5 1.5a.5.5 0 0 1 .5.5v4.8a2.5 2.5 0 0 1-2.5 2.5H2.707l3.347 3.346a.5.5 0 0 1-.708.708l-4.2-4.2a.5.5 0 0 1 0-.708l4-4a.5.5 0 1 1 .708.708L2.707 8.3H12.5A1.5 1.5 0 0 0 14 6.8V2a.5.5 0 0 1 .5-.5" />
          </svg>
        </Link>
      </div>
      <main>
        <h1 className="text-body-emphasis">{book.title}</h1>
        <p className="fs-5 col-md-8">
          <code>Author:</code>
          {' '}
          {book.author}
        </p>
        <hr className="my-4" />

        {book.available
          ? (
            <>
              <div className="d-flex mb-4">
                <h1 className="text-body-emphasis bg-success">Available</h1>
              </div>
              <div className="mb-5">
                <div className="mb-4">
                  <h2 className="text-body-emphasis">Choose pick up time</h2>
                  <DatePicker
                    showTimeSelect
                    minTime={new Date(0, 0, 0, 9, 0)}
                    maxTime={new Date(0, 0, 0, 18, 0)}
                    dateFormat="MMMM d, yyyy h:mmaa"
                    locale="en"
                    selected={pickUpTime}
                    onChange={(date) => setPickUpTime(date)}
                    className="form-control me-5"
                  />
                </div>

                <button type="button" className="btn btn-primary btn-lg px-4" onClick={reserve}>Reserve</button>

                {errors.length > 0 && errors.map((error) => (
                  <div className="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                    {error}
                    <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close" />
                  </div>
                ))}

                {reservation.reservation_token
                  && (
                  <div className="alert alert-success alert-dismissible fade show mt-3" role="alert">
                    Reservation created with success!
                    {' '}
                    Please go to our beloved library by the time you scheduled to avoid issues.
                    {' '}
                    And don&apos;t forget your reservation number!
                    <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close" />
                  </div>
                  )}

                <hr className="my-4" />
                {reservation.reservation_token
                  && (
                  <h2 className="text-body-emphasis mt-3">
                    Your reservation number:
                    {' '}
                    <span className="badge text-bg-light">{reservation.reservation_token}</span>
                  </h2>
                  )}
              </div>
            </>
          )
          : (
            <div className="d-flex mb-4">
              <h1 className="text-body-emphasis bg-danger">Not Available</h1>
            </div>
          )}
      </main>
    </div>
  );
}

export default Book;
