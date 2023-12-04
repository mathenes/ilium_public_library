import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from '../components/Home';
import BookSearch from '../components/BookSearch';
import Book from '../components/Book';

export default function LoadRouter() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/books/search" element={<BookSearch />} />
        <Route path="/books/:id" element={<Book />} />
      </Routes>
    </Router>
  );
}
