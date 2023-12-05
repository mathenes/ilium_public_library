import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';

function BookSearch() {
  const navigate = useNavigate();
  // eslint-disable-next-line no-unused-vars
  const [searchParams, setSearchParams] = useSearchParams();
  const [type, setType] = useState(searchParams.get('type') || 'title');
  const [query, setQuery] = useState(searchParams.get('query') || '');
  const [results, setResults] = useState([]);

  const search = () => {
    const baseUrl = '/books/search';
    const completeUrl = `${baseUrl}?type=${type}&query=${query}`;

    fetch(completeUrl, {
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error('Network response was not ok.');
      })
      .then((res) => setResults(res))
      .catch(() => navigate('/'));
  };

  useEffect(() => {
    if (query) {
      search();
    }
  }, []);

  const urlWithQueryParams = (book) => {
    searchParams.set('type', type);
    searchParams.set('query', query);
    const url = `/books/${book.id}`;
    return `${url}?${searchParams.toString()}`;
  };

  const renderResults = () => (
    results.map((book) => (
      <div className="p-2 text-center bg-body-tertiary rounded-3 mb-2" key={book.id}>
        <Link
          to={book.available ? urlWithQueryParams(book) : null}
          className={book.available ? 'btn' : 'btn pe-none'}
          role="button"
        >
          <div className="d-flex align-items-center">
            <h1 className="text-body-emphasis me-2">{book.title}</h1>
            {book.available
              ? <span className="badge bg-success">Available</span>
              : <span className="badge bg-danger">Not available</span>}
          </div>
        </Link>
        <p className="lead">
          <code>Author:</code>
          {' '}
          {book.author}
        </p>
      </div>
    ))
  );

  return (
    <div className="col-lg-8 mx-auto p-4 py-md-5">
      <main>
        <h1 className="text-body-emphasis">Search for Books</h1>
        <p className="fs-5 col-md-8">Search by book&apos;s title or author.</p>
        <hr className="my-4" />

        <div className="mb-5">
          <div>
            <div className="form-check">
              <input type="radio" name="search_by" className="form-check-input" id="exampleRadio1" value="title" onChange={(e) => setType(e.target.value)} defaultChecked={type === 'title'} />
              {/* eslint-disable-next-line jsx-a11y/label-has-associated-control */}
              <label className="form-check-label" htmlFor="exampleRadio1">By Title</label>
            </div>

            <div className="mb-3 form-check">
              <input type="radio" name="search_by" className="form-check-input" id="exampleRadio2" value="author" onChange={(e) => setType(e.target.value)} defaultChecked={type === 'author'} />
              {/* eslint-disable-next-line jsx-a11y/label-has-associated-control */}
              <label className="form-check-label" htmlFor="exampleRadio2">By Author</label>
            </div>

            <div className="mb-3">
              <input type="text" className="form-control" defaultValue={query} onChange={(e) => setQuery(e.target.value)} />
            </div>

            <button type="button" className="btn btn-primary" onClick={search}>Search</button>
          </div>
        </div>

        {results.length > 0
          && (
            <div className="container my-5">
              {renderResults()}
            </div>
          )}
      </main>
    </div>
  );
}

export default BookSearch;
