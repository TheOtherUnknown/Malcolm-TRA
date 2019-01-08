module Bot::DiscordEvents
  # Every time a user joins the server, send one of the set welcome messages.
  module UserJoin
    extend Discordrb::EventContainer
    member_join do |event|
      event.server.text_channels[0].send("\u200B#{event.user.mention} has joined. #{configatron.welcome[rand(configatron.welcome.length - 1)]}")
    end
  end
end
