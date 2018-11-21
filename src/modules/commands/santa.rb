# frozen_string_literal: true

require 'sqlite3'
module Bot::DiscordCommands
  # Registration and admin for secret santa bot - Requires additional gems and config
  module SecretSanta
    extend Discordrb::Commands::CommandContainer
    include Bot
    db = SQLite3::Database.new 'data/santa.sqlite3'
    command :santa do |event|
      break unless event.channel.type == 1

      # Prepare the SQL insert statement for later, prevents SQL injection?
      ins_sql = db.prepare("INSERT INTO users(username, uid, pref, other)
                  VALUES(?, ?, ?, ?)")
      event << 'Welcome to Secret Santa registration for the Ranger\'s Apprentice!'
      event << 'What would you like for Christmas? Think of a few Ranger\'s Apprentice themed gift ideas deliverable online.'
      sleep 3
      event << 'When you\'re ready, send one message detailing your prefrences. I\'ll wait until you\'re ready. Or, say Quit.'
      userd = [(event.user.name + '#' + event.user.discrim).to_s, event.user.id.to_s]
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
            if info_event.message.content.casecmp?('submit')
              begin
                ins_sql.execute(userd[0], userd[1], userd[2], userd[3])
              # This probably means the user is already registered, do update
              rescue SQLite3::ConstraintException
                db.prepare('UPDATE users SET pref=?, other=? WHERE uid=?').execute(userd[2], userd[3], userd[1])
              rescue SQLite3::Exception => e
                info_event.respond("```#{e}```")
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
        FileUtils.chmod(0o444, 'data/santa.sqlite3')
        event << 'Let\'s get started!'
        db.results_as_hash = true
        ALL = db.query('SELECT * FROM users')
        ALL.each do |current|
          next if current['matched'] != 0

          ins_m = db.prepare("UPDATE users SET matched=? WHERE rid=#{current['rid']}")
          event << "Enter a match for #{current['username']} (#{current['uid']}) :"
          event << "Wants: #{current['pref']}"
          event.channel.await(:match) do |match_e|
            match = db.query('SELECT * FROM users WHERE rid=?', match_e.message.content.to_i)
            BOT.user(current['uid'].to_i).pm("Your match has arrived! \n Username: #{match['username'].gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')} ")
            ins_m.execute(match['uid'])
          end
        end
      else
        'What are the odds? The registration pool sure is! Please register yourself to make it even.'
      end
    end
  end
end
