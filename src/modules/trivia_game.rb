require 'sqlite3'
# This class drives the trivia game functionality. See commands/trivia.rb
# Thanks, Roland
class TriviaGame
  @@game_channels = []
  @@trivia_db = SQLite3::Database.new 'data/trivia.db'
  # Creates the TriviaGame object and reserves Discordrb::Commands::CommandEvent#channel so only one operation can be preformed at one time in the same channel.
  # @param event [Discordrb::Commands::CommandEvent] The event which called for the game to start
  def initialize(event)
    @event = event
    @@trivia_db.results_as_hash = true
    @players = {}
    @players.default = 0
    @@game_channels.push(@event.channel)
  end

  # Asks new questions, and checks the answer while updating scores. Calls #open_channel and stops if the answer is stop or no one answers in time.
  # @param score [Integer] the score needed to win
  # @return nil if a game is stopped or the winner of the game
  def start(score)
    until winner?(score)
      begin
          ques = @@trivia_db.query('SELECT question, answer FROM trivia WHERE id=?', 1 + rand(@@trivia_db.query('SELECT Count(*) FROM trivia').next[0])).next
      rescue SQLite3::Exception
        @event.respond('Unable to query database!')
        return open_channel
        end
      @event.respond(ques['question']) # Ask the question
      answer = @event.channel.await!(timeout: 60)
      if answer # Was there an answer before the timeout?
        cleanans = answer.content.gsub(/\W/, '').downcase # Clean up the answer by removing caps and non [a-z] [0-9] chars
        if cleanans == ques['answer'] # There was an answer! You guessed right!
          @event.respond('You got it!')
          sleep 3
          @players[answer.user] += 1
        elsif cleanans == 'stop' # There was an answer! It was stop
          @event.respond('Exiting...')
          return open_channel
        else # There was an answer! It was wrong!
          @event.respond('Nope! Moving on...')
          sleep 3
        end
      else # No answer
        event.respond('Well, alright then. Exiting...')
        return open_channel
      end
    end
  end

  # Checks if someone has won the game. If so, updates rankings and announces the winner before calling #open_channel
  # @param score [Integer] The score needed to win
  # @return true if someone won, false if not
  def winner?(score)
    return false unless @players.value?(score)

    @event.respond('And that\'s the game!')
    sleep 3
    winner = @players.key(score)
    @event.respond("#{winner.name} wins!")
    @@trivia_db.prepare('INSERT OR IGNORE INTO score(id) VALUES(?)').execute(winner.id) # Add a user if they don't exist
    @@trivia_db.prepare('UPDATE score SET rank = rank + 1 WHERE id = ?').execute(winner.id) # Add 1 to score
    open_channel
    true
  end

  # Makes the channel available to another game
  # @return Nil
  def open_channel
    @@game_channels.delete(@event.channel)
    nil
  end

  # Prints the leaders from the database
  def leaders
    scores = '```User:                            Wins:'
    @@trivia_db.execute('SELECT id, rank FROM score ORDER BY rank DESC LIMIT 5') do |row| # Get the top 5, add to the printed string
      scores += "\n" + Bot::BOT.user(row['id']).name.ljust(33) + row['rank'].to_s # Usernames can be 32 chars, so ljust by 33
    end
    scores += '```'
    @event.respond(scores)
    open_channel
  end

  # Adds a question to the trivia database
  def add_question
    @event.respond('Enter a new question: ')
    ques = @event.user.await!(timeout: 60)
    return open_channel if ques.nil?

    ques = ques.content
    @event.respond('Enter the answer: ')
    ans = @event.user.await!(timeout: 60)
    return open_channel if ans.nil?

    ans = ans.content.gsub(/\W/, '').downcase # Clean up the answer by removing caps and non [a-z] [0-9] chars
    @event.respond('Commit to database? (y/n): ')
    prompt = @event.user.await!(timeout: 60)
    unless prompt.nil? || prompt.content != 'y'
      begin
      @@trivia_db.prepare('INSERT INTO trivia(question, answer, addedby) VALUES(?, ?, ?)').execute(ques, ans, event.user.id)
      rescue SQLite3::Exception
        event.respond('Unable to write to database!')
      else
        event.respond('Changes saved')
    end
    end
    open_channel
  end

  # @returns true if the TriviaGame's channel is not being used by another game
  def channel_free?
    i = 0
    @@game_channels.each do |chann|
      i += 1 if @event.channel == chann
    end
    return true if i == 1

    open_channel
    false
  end
end
