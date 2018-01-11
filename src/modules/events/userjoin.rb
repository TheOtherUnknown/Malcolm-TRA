module Bot::DiscordEvents
  # Every time a user joins the server, send one of the set welcome messages.
  module UserJoin
    extend Discordrb::EventContainer
    member_join do |_event|
      welcome = ['Leave your weapons at the door.', 'We just ran out of coffee.',
                 "You'll have to be better than that to not be spotted.", 'Trust the cloak.']
      '{#event.user.mention} has joined. ' + welcome[rand(welcome.length - 1)]
    end
  end
end