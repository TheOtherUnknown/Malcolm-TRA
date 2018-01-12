module Bot::DiscordEvents
  # Send a user leave message preceeded by a 0-width space. 
  module UserPart
    extend Discordrb::EventContainer
    member_leave do |event|
      '\u200B' + event.username + ' has left the server.'
    end
  end
end