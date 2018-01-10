module Bot::DiscordEvents
  # Every time a user joins the server, send one of the set welcome messages.  
  module UserJoin
    extend Discordrb::EventContainer
    user_join do |event|
      welcome = ["Leave your weapons at the door.", "We just ran out of coffee.",
      "You'll have to be better than that to not be spotted.", "Trust the cloak."]
     msg = welcome[rand(welcome.length -1)];
      "{#event.user.mention} has joined. {#msg}"
    end
  end
end