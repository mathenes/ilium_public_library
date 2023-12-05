# frozen_string_literal: true

namespace :users do
  task :make_user_a_clerk, [:email] => [:environment] do |_, args|
    puts 'Initializing task'
    user = User.find_by(email: args[:email])
    unless user
      puts 'User not found'
      puts 'Task finished'
      next
    end

    if user.member.library_clerk!
      puts 'User became a clerk!'
    else
      puts "There was an issue when switching the user's member"
    end

    puts 'Task finished'
  end
end
