# frozen_string_literal: true

require 'sqlite3'
module Bot::DiscordCommands
  # Registration and admin for secret santa bot - Requires additional gems and config
  module SecretSanta
    extend Discordrb::Commands::CommandContainer
    db = SQLite3::Database.new 'data/santa.sqlite3'
    command :santa do |event|
      break unless event.channel.type == 1

      event << 'Welcome to Secret Santa registration for the Ranger\'s Apprentice!'
      event << 'What would you like for Christmas? Think of a few Ranger\'s Apprentice themed gift ideas deliverable online.'
      sleep 3
      event << 'When you\'re ready, send one message detailing your prefrences. I\'ll wait until you\'re ready. Or, say Quit.'
      userd = [(event.user.name + event.user.discrim).to_s, event.user.id.to_s]
      event.user.await(:info) do |info_event|
        return 'Exiting...' if info_event.message.content.casecmp('quit').zero?

        case userd.length
        when 2
          userd.insert(-1, info_event.message.content)
          info_event.respond('Great! What else would you like to tell your gift giver about you?')
          info_event.respond('This may include general biographical information.')
          false
        when 3
          userd.insert(-1, info_event.message.content)
          info_event.respond('Alright, here\'s what we have so far:')
          sleep 3
          info_event.respond("Username: **#{userd[0]}** (ID: #{userd[1]})")
          info_event.respond('Gift prefrences:')
          info_event.respond(userd[2])
          sleep 3
          info_event.respond('Other info:')
          info_event.respond(userd[3])
          sleep 3
          info_event.respond('If everything looks okay, say `Submit` to finish or anything else to quit.')
          false
        when 4
          return 'Exiting...' unless info_event.message.content.casecmp?('submit')

          begin
            db.execute("INSERT INTO users(username, uid, pref, other)
              VALUES(?, ?, ?, ?)", userd[0], userd[1], userd[2], userd[3])
          rescue SQLite3::Exception => e
            info_event.respond("```#{e}```")
          else
            info_event.respond('Registraton succesful! You will recieve your match soon.')
          end
        end
      end
    end
    command :raindeer do |event|
      break unless event.user.id == configatron.owner

      db.close
      total_users = db.query('SELECT COUNT(*) FROM users')
      if total_users.even?
        # Run match
        FileUtils.cp('data/santa.sqlite3', 'data/backup_santa.sqlite3')
        FileUtils.chmod(0o444, 'data/backup_santa.sqlite3')
        db.results_as_hash = true
        db.execute('SELECT * FROM users') do |row|
          # Send match messages
        end
      else
        'What are the odds? The registration pool sure is! Please register yourself to make it even.'
      end
    end
  end
end
