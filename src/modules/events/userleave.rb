module Bot::DiscordEvents
  # Send a user leave message preceeded by a 0-width space.
  module UserPart
    extend Discordrb::EventContainer
    member_leave do |event|
      event.server.default_channel.send("\u200B#{event.user.name} has left the server.")
    end
  end
end
