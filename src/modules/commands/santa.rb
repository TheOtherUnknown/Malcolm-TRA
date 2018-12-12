# frozen_string_literal: true

require 'sqlite3'
module Bot::DiscordCommands
  # Registration and admin for secret santa bot - Requires additional gems and config
  module SecretSanta
    extend Discordrb::Commands::CommandContainer
    include Bot
    db = SQLite3::Database.new 'data/santa.db'
    command :santa do |event|
      break unless event.channel.type == 1 && configatron.santa

      # Prepare the SQL insert statement for later, prevents SQL injection?
      ins_sql = db.prepare("INSERT INTO users(username, uid, pref, other, giving)
                  VALUES(?, ?, ?, ?, ?)")
      event << 'Welcome to Secret Santa registration for the Ranger\'s Apprentice!'
      event << 'What would you like for Christmas? Think of a few Ranger\'s Apprentice themed gift ideas deliverable online.'
      sleep 3
      event << 'When you\'re ready, send one message detailing your prefrences. I\'ll wait until you\'re ready. Or, say Quit.'
      userd = [(event.user.name + '#' + event.user.discrim).to_s, event.user.id]
      event.channel.await(:info) do |info_event|
        unless info_event.message.content.casecmp('quit').zero?
          case userd.length
          when 2
            userd.insert(-1, info_event.message.content)
            info_event.respond('Great! What else would you like to tell your gift giver about you?')
            info_event.respond('This may include general biographical information.')
            false
          when 3
            userd.insert(-1, info_event.message.content)
            info_event.respond('Got it. What would you like to *give* this year? (A specific oneshot, drawing, etc)')
            false
          when 4
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
            info_event.respond('If everything looks okay, say `Submit` to finish or anything else to quit. Please remember that ghosting the event will result in a ban.')
            false
          when 5
            if info_event.message.content.casecmp?('submit')
              begin
                ins_sql.execute(userd[0], userd[1], userd[2], userd[3], userd[4])
              # This probably means the user is already registered, do update
              rescue SQLite3::ConstraintException
                db.prepare('UPDATE users SET pref=?, other=?, giving=? WHERE uid=?').execute(userd[2], userd[3], userd[4], userd[1])
                info_event.respond('You are already registered, attempting update')
              rescue SQLite3::Exception => e
                info_event.respond("Unable to write to DB! ```#{e}```")
              else
                info_event.respond('Registraton succesful! You will recieve your match soon.')
              end
            else
              true
            end
          else
            true
          end
        end
      end
    end
    command :raindeer do |event|
      break unless event.user.id == configatron.owner

      total_users = db.query('SELECT COUNT(*) FROM users')
      if total_users.next[0].even?
        # Run match
        event.respond('Let\'s get started!')
        db.results_as_hash = true
        ALL = db.query('SELECT * FROM users')
        ALL.each do |current|
          # next if current['matched'] != 0

          ins_m = db.prepare('UPDATE users SET matched=? WHERE rid=?')
          event.respond("Enter a match for #{current['username']} (#{current['uid']}) :")
          event.respond("Wants: #{current['pref']}")
          match_e = event.channel.await!
          match = db.query('SELECT * FROM users WHERE rid=?', match_e.message.content.to_i).next
          BOT.user(current['uid'].to_i).pm("Your match has arrived! \n Username: #{match['username'].gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')} \n Gift preferences: #{match['pref']} \n Other information: #{match['other']} ")
          puts "PM sent to #{current['username']} " # Debug, remove later
          ins_m.execute(match['uid'], current['rid'])
        end
        event.respond('That\'s everyone! Merry Christmas to all!')
      else
        'What are the odds? The registration pool sure is! Please register yourself to make it even.'
      end
    end
  end
end
