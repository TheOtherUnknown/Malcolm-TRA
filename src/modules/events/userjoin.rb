module Bot::DiscordEvents
  # Every time a user joins the server, send one of the set welcome messages.
  module UserJoin
    extend Discordrb::EventContainer
    welcome = ['Leave your weapons at the door.', 'We just ran out of coffee.',
               "You'll have to be better than that to not be spotted.", 'Trust the cloak.']
    member_join do |event|
      # TODO: find out how #text_channels is sorted. Why does this work?
      event.server.text_channels[0].send_temporary_message("\u200B#{event.user.mention} has joined. #{welcome[rand(welcome.length - 1)]}", 90)
    end
  end
end
