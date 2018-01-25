module Bot::DiscordCommands
  # Return server info, including a user count on command
  module ServerInfo
    extend Discordrb::Commands::CommandContainer
    command(:serverinfo, description: 'Display this server\'s basic info.', usage: 'serverinfo') do |event|
      event << '**' + event.server.name + '**'
      event << 'Owner: ' + event.server.owner.username
      event << "Users: #{event.server.member_count}"
      event << "Online: #{event.server.online_members.count}"
      event << event.server.icon_url
      event << 'Region: ' + event.server.region
    end
  end
end
