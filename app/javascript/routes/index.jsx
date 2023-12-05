import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from '../components/Home';
import BookSearch from '../components/BookSearch';
import Book from '../components/Book';
import ReservationSearch from '../components/ReservationSearch';
import Reservation from '../components/Reservation';

export default function LoadRouter() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/books/search" element={<BookSearch />} />
        <Route path="/books/:id" element={<Book />} />
        <Route path="/reservations" element={<ReservationSearch />} />
        <Route path="/reservations/:id" element={<Reservation />} />
      </Routes>
    </Router>
  );
}
