module Bot::DiscordCommands
  # Shutdown the bot on command from the owner
  module Quit
    extend Discordrb::Commands::CommandContainer
    command(:quit, help_available: false) do |event|
      break unless event.user.id == configatron.owner

      event.respond('Malcolm-TRA is going down NOW!')
      Bot::BOT.stop
    end
  end
end
