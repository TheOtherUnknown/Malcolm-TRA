module Bot::DiscordCommands
  # Command for evaluating Ruby code in an active bot.
  # Only the `event.user` with matching discord ID of `CONFIG.owner`
  # can use this command.
  module Eval
    extend Discordrb::Commands::CommandContainer
    command(:eval, help_available: false) do |event, *code|
      break unless event.user.id == configatron.owner
      begin
        eval code.join(' ')
      rescue StandardError => e
        "An error occurred 😞 ```#{e}```"
      end
    end
  end
end
