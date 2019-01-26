require 'sqlite3'
module Bot::DiscordCommands
  # A trivia game module which pulls questions from data/trivia.db
  module Trivia
    extend Discordrb::Commands::CommandContainer
    db = SQLite3::Database.new 'data/trivia.db'
    db.results_as_hash = true
    command :trivia, min_args: 1 do |event, action|
      # Start a new game
      answer = ''
      if action == 'start'
        event.respond('Starting trivia. 5 questions, incoming!')
        while answer != 'stop'
          ques = db.query("SELECT question, answer FROM trivia WHERE id=#{rand(5)}") # TODO: make that >5
          event.respond(ques['question'])
          answer = event.channel.await!.content
          if answer == ques['answer']
            event.respond('You got it!')
          else
            event.respond('Nope! Moving on...')
          end
        end
      # Add a new question
      elsif action == 'add' && event.user.id == configatron.owner
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
