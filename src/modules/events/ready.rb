module Bot::DiscordEvents
  # This event is processed each time the bot succesfully connects to discord.
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
      event.bot.game = configatron.game
    end
  end
end
