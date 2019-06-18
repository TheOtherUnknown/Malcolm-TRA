module Bot::DiscordCommands
  # Return server info, including a user count on command
  module ServerInfo
    extend Discordrb::Commands::CommandContainer
    command(:serverinfo, description: 'Display this server\'s basic info.', usage: 'serverinfo') do |event|
      if event.channel.type != 0
        'Info cannot be retrieved for PMs!'
      else
        event << "**#{event.server.name}**"
        event << "Owner: #{event.server.owner.username}"
        event << "Users: #{event.server.member_count}"
        event << "Online: #{event.server.online_members.count}"
        event << event.server.creation_time.strftime('Created on %B %e, %Y at %l:%M %p UTC ') + "(#{((Time.now - event.server.creation_time) / 86_400).to_i} days ago)"
        event << event.server.icon_url
        event << "Region: #{event.server.region}"
      end
    end
  end
end
