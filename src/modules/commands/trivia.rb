require 'sqlite3'
module Bot::DiscordCommands
  # A trivia game module which pulls questions from data/trivia.db
  module Trivia
    extend Discordrb::Commands::CommandContainer
    db = SQLite3::Database.new 'data/trivia.db'
    command :trivia, min_args: 1 do |event, action|
      # Start a new game
      if action == 'start'
        event.respond('Starting trivia. 5 questions, incoming!')

      # Add a new question
      elsif action == 'add' && event.user.id == configatron.owner
        event.respond('Enter a new question: ')
        ques = event.user.await!
        event.respond('Enter the answer: ')
        ans = event.user.await!
        event.respond('Commit to database? (y/n): ')
        if event.user.await! == 'y'
          begin
            db.prepare('INSERT INTO trivia(question, answer) VALUES(?, ?)').execute(ques, ans)
          rescue SQLite3::Exception
            event.respond('Unable to write to database!')
          else
            event.respond('Changes saved')
          end
        end
      elsif action == 'stop'
        # Change flag
      end
    end
  end
end
