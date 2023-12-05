# frozen_string_literal: true
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#

books_data = [
  { title: 'To Kill a Mockingbird', author: 'Harper Lee', total_amount: 1 },
  { title: '1984', author: 'George Orwell', total_amount: 3 },
  { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', total_amount: 2 },
  { title: 'Pride and Prejudice', author: 'Jane Austen', total_amount: 6 },
  { title: 'The Catcher in the Rye', author: 'J.D. Salinger', total_amount: 5 },
  { title: 'Animal Farm', author: 'George Orwell', total_amount: 4 },
  { title: 'Brave New World', author: 'Aldous Huxley', total_amount: 1 },
  { title: 'The Hobbit', author: 'J.R.R. Tolkien', total_amount: 2 },
  { title: 'The Lord of the Rings', author: 'J.R.R. Tolkien', total_amount: 3 },
  { title: 'The Chronicles of Narnia', author: 'C.S. Lewis', total_amount: 5 },
  { title: 'Harry Potter and the Sorcerer\'s Stone', author: 'J.K. Rowling', total_amount: 3 },
  { title: 'The Shining', author: 'Stephen King', total_amount: 3 },
  { title: 'The Hitchhiker\'s Guide to the Galaxy', author: 'Douglas Adams', total_amount: 6 },
  { title: 'The Da Vinci Code', author: 'Dan Brown', total_amount: 2 },
  { title: 'The Girl with the Dragon Tattoo', author: 'Stieg Larsson', total_amount: 4 },
  { title: 'The Hunger Games', author: 'Suzanne Collins', total_amount: 7 },
  { title: 'The Kite Runner', author: 'Khaled Hosseini', total_amount: 2 },
  { title: 'The Alchemist', author: 'Paulo Coelho', total_amount: 4 },
  { title: 'One Hundred Years of Solitude', author: 'Gabriel Garcia Marquez', total_amount: 5 },
  { title: 'The Road', author: 'Cormac McCarthy', total_amount: 3 }
]

books_data.each do |book|
  Book.find_or_create_by!(book)
end
