module Bot::DiscordCommands
  # Responds with "Pong!" and a time based on timestamps. Ratelimited.
  module Ping
    extend Discordrb::Commands::CommandContainer
    command :ping, bucket: :wait90 do |event|
      m = event.respond('Pong!')
      ping = (Time.now - event.timestamp)
      m.edit "Pong! Time taken: #{ping} seconds."
    end
  end
end
