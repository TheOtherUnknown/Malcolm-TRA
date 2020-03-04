module Bot::DiscordEvents
  # Send a user leave message preceeded by a 0-width space.
  module UserPart
    extend Discordrb::EventContainer
    user_ban do |event|
      event.server.text_channels[0].send("\u200B#{event.user.name.gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')}\##{event.user.discrim} has been banned.")
    end
    member_leave do |event|
      event.server.text_channels[0].send("\u200B#{event.user.name.gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')}\##{event.user.discrim} has left the server.")
    end
  end
end
