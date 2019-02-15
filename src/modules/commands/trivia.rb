require 'sqlite3'
module Bot::DiscordCommands
  # A trivia game module which pulls questions from data/trivia.db
  module Trivia
    include Bot
    extend Discordrb::Commands::CommandContainer
    db = SQLite3::Database.new 'data/trivia.db'
    db.results_as_hash = true
    command :trivia, min_args: 1 do |event, action|
      # Start a new game
      if action == 'start'
        players = {} # Hash of all players. USERID => score
        players.default = 0
        answer = ''
        event.respond('Starting trivia. The first to 5 points wins!')
        while answer.content != 'stop'
          # Get a random question from the DB and store it in a Hash
          ques = db.query('SELECT question, answer FROM trivia WHERE id=?', 1 + rand(db.query('SELECT Count(*) FROM trivia').next[0])).next
          event.respond(ques['question']) # Ask the question
          answer = event.channel.await!
          if answer.content == ques['answer'] # You guessed right!
            event.respond('You got it!')
            sleep 3
            players[answer.user.id] += 1
          else # You guessed wrong!
            event.respond('Nope! Moving on...')
            sleep 3
          end
          next unless players.value?(5) # Rubocop insists on this instead of using if. Who knows why. Does someone have a score of 5?
          event.respond('And that\'s the game!')
          sleep 3
          event.respond("#{BOT.user(players.key(5)).name} wins!")
          answer = 'stop' # Kill the loop
        end
      # Add a new question
      elsif action == 'add' # && event.user.id == configatron.owner
        event.respond('Enter a new question: ')
        ques = event.user.await!.content
        event.respond('Enter the answer: ')
        ans = event.user.await!.content
        event.respond('Commit to database? (y/n): ')
        if event.user.await!.content == 'y'
          begin
            db.prepare('INSERT INTO trivia(question, answer) VALUES(?, ?)').execute(ques, ans)
          rescue SQLite3::Exception
            event.respond('Unable to write to database!')
          else
            event.respond('Changes saved')
          end
        end
      end
    end
  end
end
