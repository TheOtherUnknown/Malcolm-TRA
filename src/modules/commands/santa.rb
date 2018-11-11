# frozen_string_literal: true

require 'sqlite3'
module Bot::DiscordCommands
  # Registration and admin for secret santa bot - Requires additional gems and config
  module SecretSanta
    extend Discordrb::Commands::CommandContainer
    command :santa do |event|
      break unless event.channel.type.zero?

      db = SQLite3::Database.new 'santa.sqlite3'
      event << 'Welcome to Secret Santa registration for the Ranger\'s Apprentice!'
      event << 'What would you like for Christmas? Think of a few Ranger\'s Apprentice themed gift ideas deliverable online.'
      event << 'When you\'re ready, send one message detailing your prefrences. I\'ll wait until you\'re ready. Or, say Quit.'
      event.user.await(:pref) do |pref_event|
        return 'Exiting...' if pref_event.message.content.casecmp('quit').zero?

        userd = [event.user.name + event.user.discrim, event.user.id, pref.message.content]
        event << 'Great! Is gift delivery by Discord PM okay? (Please respond `Yes`, or with your prefered delivery method)'
        event << 'IRL methods such as mail are not allowed. Email is not recomended.'
        event.user.await(:deliv) do |deliv_event|
          if deliv_event.message.content.casecmp('yes').zero?
            userd.insert(-1, true)
          else
            userd.insert(-1, deliv_event.message.content)
          end
          db.execute('INSERT INTO users (username, uid, pref, deliv)
          VALUES(?, ?, ?, ?)', userd)
        end
        # Confirm action here
      end
    end
  end
end
