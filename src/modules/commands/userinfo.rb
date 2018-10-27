module Bot::DiscordCommands
  # Document your command
  module UserInfo
    extend Discordrb::Commands::CommandContainer
    include Bot
    command :userinfo, description: 'Shows basic user information', usage: 'userinfo <user or ID>' do |event, uid|
      mentioned = event.user
      if event.message.mentions.empty? && !uid.nil?
        mentioned = BOT.user(uid.to_i)
        return 'User ID lookup failed.' if mentioned.nil?

        mentioned = mentioned.on(event.server)
      elsif !event.message.mentions.empty?
        mentioned = event.message.mentions.first.on(event.server)
      end
      event << "**#{mentioned.name}**"
      event << "Joined on #{mentioned.joined_at}"
      roles = ''
      mentioned.roles.each do |x|
        roles = x.name + ' '
      end
      event << "Member of #{roles}"
      event << 'User is the server owner' if mentioned.owner?
      event << 'This user is a bot' if mentioned.current_bot?
      event << "User ID: #{mentioned.id}"
    end
  end
end
