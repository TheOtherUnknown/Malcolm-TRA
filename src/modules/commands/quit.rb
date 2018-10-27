module Bot::DiscordCommands
  # Shutdown the bot on command from the owner
  module Exit
    extend Discordrb::Commands::CommandContainer
    command(:quit, help_available: false) do |event|
      break unless event.user.id == configatron.owner

      exit
    end
  end
end
