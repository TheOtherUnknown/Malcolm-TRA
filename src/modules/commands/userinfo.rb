module Bot::DiscordCommands
  # Document your command
  module UserInfo
    extend Discordrb::Commands::CommandContainer
    command :userinfo, description: 'Shows basic user information', usage: 'userinfo <user>' do |event|
      if event.message.mentions.empty?
        event << "**#{event.user.name}**"
        event << "Joined on #{event.user.on(event.server).joined_at}"
        roles = ''
        event.user.on(event.server).roles.each do |x|
          roles = x.name + ', '
        end
        event << "Member of #{roles}"
        event << 'User is the server owner' if event.user.on(event.server).owner?
        event << 'This user is a bot' if event.user.current_bot?
        event << "User ID: #{event.user.id}"
      else
        mentioned = event.message.mentions.first
        event << "**#{mentioned.name}**"
        event << "Joined on #{event.user.on(event.server).joined_at}"
        roles = ''
        mentioned.on(event.server).roles.each do |x|
          roles = x.name + ', '
        end
        event << "Member of #{roles}"
        event << 'User is the server owner' if mentioned.on(event.server).owner?
        event << 'This user is a bot' if mentioned.current_bot?
        event << "User ID: #{mentioned.id}"
      end
    end
  end
end
