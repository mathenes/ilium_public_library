# README

## Intro
Hello!

This app is for a code challenge.
It was required from me to build a simple book loan system.

## Requeriments

`Ruby version: 3.1.0`
`node version: v18.18.2`
`database: PostgreSQL`

* Clone the repo
* cd to it
* Run `bundle install`
* Run `bin/setup`
* Run `bin/dev`
* Create a `user`. Click on `Sign in` and then `Sign up`. (creates a user member)
* If you want to switch an user to clerk run `rails 'users:make_user_a_clerk[user_email@test.com]'`

## Test

* Run `rspec`

## About

So, talking a bit about my decisions for this project.
I've added a bunch of details to the PRs, so will copy them here if that's ok.

PostgreSQL was recommended to be used.
For the fronted I decided to go with React, could go with standard ERB/HAML, but by using React I could show other skills.
So, as we will use React for the frontend, I decided to go with ESBuild because it'll be a simple project and they claim to be "An extremely fast bundler for the web" - and also to try it out as I never used it.
Bootstrap was added as I didn't want to spend much time with CSS, so I've used some of their examples. Turned out to be kinda nice.
I've also added Rubocop and eslint as my linters for ruby/js.

### Database

This is the database diagram I thought about.
Sorry if it's a bit raw, I just bought a pen for my iPad and wanted to try it out. =]
As you can see it has the main attributes and associations between them.
Some attributes names changed but the stucture is the same.
<img width="500" alt="image" src="https://github.com/mathenes/ilium_public_library/assets/852649/93d3943d-db76-4f5e-9bd1-2a0ce12865fc">

So, continuing, a User has_one Member meaning that a User can be a Member of the Library. It was created with Devise because the application requires users to log in and Devise already provides everything that is necessary.
A Member belongs_to a User, which means that it’s the entity that holds the id from their association. A Member hast the type attribute with the following values: `library_member`, `library_clerk`.

A Reservation belongs_to a Book and to a User, which means that it’s the entity that holds their association and that a Reservation is created for a specific User that wants a specific Book. Hence, a User has_many Reservations with different Books and a Book also has_many Reservations with different Users. A User can have only one Reservation of a Book in a given time. Only once the User delivers the Book, they can reserve again.
I've also added a state machine to Reservation in order to control better the current state of the Reservation which can be: `reserved`, `lent`, `delivered` or `canceled`.

A Book as mentioned above has_many Reservations, a title and name for the main queries and a total_amount. This amount refers to the amount of copies the library has for this book. Active Reservations will rely on this to allow or not the book to be reserved.

It seemed a bit weird that after deleting an user or a book, all the reservations linked to it would get deleted as well.
On the other side if don't do this we could end up having edge cases like a book getting deleted and a user having active reservations with it;
Or an user getting deleted still having active reservations for a book.
Would it mean that the book would never be returned?
To prevent this I added a dependent: `:exception_with_error` to both User and Book `has_many: :reservations` so that a user or a book cannot be deleted in case there’s a reservation linked to it.
I've also added foreign keys in the reservations table to users and books.

I have added Rspec and Shoulda Matches gems for testing. Rspec because it's awesome and widely used since forever and Shoulda Matchers because I wanted to try something new. Seems interesting to add one liners for default validations that we always need to think about. I also added Factory Bot to use our beloved factories for testing as well.

### Members business logic
I've developed the business logic for the library members, which means searching and reserving a book.

#### Frontend
I've created a Home.jsx to handle the home page info. It shows the link for the search page and also the Sign In.
It fetches the index action in home_controller to get current_user data - his email and member.

Regarding the business logic structure, 2 simple React components handle the frontend logic `BookSearch.jsx` and `Book.jsx`.

`BookSearch` component is about searching for the books based on title or author.
Then a list of books is shown to the user with a badge informing if the book is available or not available.
Non available book don't have a working link.
Which is the opposite with available ones. For them the link works and sends the user to the book show page where he can schedule a pick up time.

For the pick up time I thought it would be interesting to add `react-date-picker` package to help with the date and time selection. The downside is that I couldn't make its css to work by importing it like the documentation said. It seems that eslint could not post process the css. So I had to include the css into the application layout.
I was having issues to save the date (especially the time) correctly. As the datepicker was getting my timezone, the database was saving a difference UTC thanit was supposed to be saving to match the library's time.
So I needed to add `moment-timezone` package to be able to convert my local time to the server's (library location) timezone. This way the hours got saved correctly.

Backend
On the Rails side of things, I added 3 controllers: `books/search_controller.rb`, `books/reservations_controller.rb` and `books_controller.rb`. They are restful and implement only one method each (until now).
I've also added Pundit for different authorizations between `library_clerk` and `library_member`.

For `books/search_controller.rb` I implemented an index action for the title and author queries. I also needed to add some new scopes in Book. To render the elements I am using a jbuilder view. Within that view I am rendering a book's jbuilder partial with basic book data and a available_for?(user:) method. This is a new method which checks if a book is available for an user - better said the current_user. The action responds to hmtl and json, because it's being used for both formats.

For `books/reservations_controller.rb` I implemented the create action. It's a simple create logic with a Pundit's "authorize". Then render a json with the new reservation's data to be shown in the frontend.

For `books_controller.rb` I implemented the show action. Pretty standard with a Pundit's "authorize". It also renders the book data using a jbuilder view. It also responds to hmtl and js

Inside `config/application` I've uncommented the `config.time_zone = 'Central Time (US & Canada)'` line. I am only assuming that the library is in this location with this timezone. I've discussed about what I did in the frontend with moment-timezone.

### Clerks business logic
I've developed the business logic for the library clerks, which means searching for a reservation number and recording the book as lent or delivered (or canceled).

#### Frontend

Again 2 React components handle the frontend logic: `ReservationSearch.jsx` and `Reservation.jsx`.

`ReservationSearch` component is about searching for a reservation by using its reservation number and navigating the user to the reservation show page.

`Reservation` component is about showing the user all the infos about the member's reservation for a specific book.
In there, the user (which is a library clerk - Pundit is taking care of that) can change the reservation's state or canceling it (the system is really simple, so I thought it would be interesting to allow the clerk to cancel the reservation).

#### Backend

On the Rails side of things, I added just one controller: `reservations_controller`. It's restful and implement 3 methods.
Again, I've added Pundit's authorization as changing the state should be allowed only for the library clerks. It responds to hmtl and json, because it's being used for both formats.

Regarding the controller's actions, I implemented an index action for the reservation query using the reservation_token. To render the reservation I am using a jbuilder view (using it in all actions).

I've also implemented the show action which is pretty straightforward. It also responds to hmtl and json.

Lastly I've implemented the update action. There's a bit more of logic in here as it handles the reservation's state update.
For that I've remove the logic from the controller and created a simple class called ManageReservation, under the Reservations namespace. This class is responsible for changing the reservation state based on a specific required action. Then it returns the reservation or the errors if it was not successful.

### Possible future upgrades

* Creation/edit page for books
* Send email to member with the reservation number
* Create daily cron job to cancel books that were reserved and never picked up
* An admin page to handle role change
* Pagination for the book search page
* A page to list all books
* A page to list all user’s reservations
* A page for the Clerck to list all active reservations
* Create a QR code with a link for the reservation page with the reservation number
* ... so many ideas!





