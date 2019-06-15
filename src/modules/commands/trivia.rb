require 'sqlite3'
module Bot::DiscordCommands
  # A trivia game module which pulls questions from data/trivia.db
  module Trivia
    include Bot
    extend Discordrb::Commands::CommandContainer
    db = SQLite3::Database.new 'data/trivia.db'
    db.results_as_hash = true
    command :trivia, min_args: 1, description: 'Trivia game management tool', usage: 'trivia [add|start|top]' do |event, action|
      # Start a new game
      if action == 'start'
        players = {} # Hash of all players. USERID => score
        players.default = 0
        answer = event.message # Must be a message to start off with. Content only used in the loop
        event.respond('Starting trivia. The first to 5 points wins!')
        loop do
          # Get a random question from the DB and store it in a Hash
          begin
            ques = db.query('SELECT question, answer FROM trivia WHERE id=?', 1 + rand(db.query('SELECT Count(*) FROM trivia').next[0])).next
          rescue SQLite3::Exception
            event.respond('Unable to query database!')
            break
          end
          event.respond(ques['question']) # Ask the question
          answer = event.channel.await!(timeout: 60)
          if answer # Was there an answer before the timeout?
            cleanans = answer.content.gsub(/\W/, '').downcase # Clean up the answer by removing caps and non [a-z] [0-9] chars
            if cleanans == ques['answer'] # There was an answer! You guessed right!
              event.respond('You got it!')
              sleep 3
              players[answer.user.id] += 1
            elsif cleanans == 'stop' # There was an answer! It was stop
              event.respond('Exiting...')
              break
            else # There was an answer! It was wrong!
              event.respond('Nope! Moving on...')
              sleep 3
            end
          else # No answer
            event.respond('Well, alright then. Exiting...')
            break
          end
          next unless players.value?(5) # Rubocop insists on this instead of using if. Who knows why. Does someone have a score of 5?

          event.respond('And that\'s the game!')
          sleep 3
          winner = players.key(5)
          event.respond("#{BOT.user(winner).name} wins!")
          db.prepare('INSERT OR IGNORE INTO score(id) VALUES(?)').execute(winner) # Add a user if they don't exist
          db.prepare('UPDATE score SET rank = rank + 1 WHERE id = ?').execute(winner) # Add 1 to score
          break # Kill the loop
        end
      # Add a new question
      elsif action == 'add' # && event.user.id == configatron.owner
        event.respond('Enter a new question: ')
        ques = event.user.await!.content
        event.respond('Enter the answer: ')
        ans = event.user.await!.content.gsub(/\W/, '').downcase # Clean up the answer by removing caps and non [a-z] [0-9] chars
        event.respond('Commit to database? (y/n): ')
        if event.user.await!.content == 'y'
          begin
            db.prepare('INSERT INTO trivia(question, answer, addedby) VALUES(?, ?, ?)').execute(ques, ans, event.user.id)
          rescue SQLite3::Exception
            event.respond('Unable to write to database!')
          else
            event.respond('Changes saved')
          end
        end
      elsif action == 'top' # Prints the top 5
        scores = "```User:\t\t\t\t\t\tWins:"
        db.execute('SELECT id, rank FROM score ORDER BY rank DESC LIMIT 5') do |row| # Get the top 5, add to the printed string
          scores += "\n" + BOT.user(row['id']).name.ljust(33) + row['rank'].to_s # Usernames can be 32 chars, so ljust by 33
        end
        scores += '```'
        event.respond(scores)
      end
    end
  end
end
