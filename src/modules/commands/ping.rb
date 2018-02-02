module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Ping
    extend Discordrb::Commands::CommandContainer
    command :ping do |_event|
      m = event.respond('Pong!')
      ping = (Time.now - event.timestamp)
      m.edit "Pong! Time taken: #{ping} seconds."
    end
  end
end
