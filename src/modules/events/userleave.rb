module Bot::DiscordEvents
  # Send a user leave message preceeded by a 0-width space.
  module UserPart
    extend Discordrb::EventContainer
    user_ban do |event|
      event.server.text_channels[0].send("\u200B#{event.user.name}\##{event.user.discrim} has been banned.")
      return
    end
    member_leave do |event|
      event.server.text_channels[0].send_temporary_message("\u200B#{event.user.name}\##{event.user.discrim} has left the server.", 90)
    end
  end
end
