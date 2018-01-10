module Bot::DiscordCommands
  # Deletes a set amount of messages from the current channel.
  module MyCommand
    extend Discordrb::Commands::CommandContainer
    command(:nuke, min_args: 1, required_permissions: [:manage_messages]) do |event, ammount|
      if event.bot.profile.on(event.server).permission? :manage_messages
        ammount = ammount.to_i
        next "Can't delete less than 2 messages." if ammount < 2

        while ammount > 100
          event.channel.prune(100)
          ammount -= 100
        end
        event.channel.prune(ammount) if ammount >= 2
        nil
   end
    end
  end
end
