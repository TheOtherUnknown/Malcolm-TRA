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
      #Escape markdown in usernames
      nick = "**#{mentioned.name.gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')}##{mentioned.discrim}**"
      nick += '👑' if mentioned.owner? # Add crown after nick if owner
      nick += '🛡️' if mentioned.permission?(:kick_members) # Add shield after nick if user can kick
      nick += '🤖' if mentioned.current_bot? # Add robot to nick if bot
      event << nick
      event << mentioned.joined_at.strftime('Joined on %B %-m, %Y at %l:%M %p UTC ') + "(#{((Time.now - mentioned.joined_at) / 86_400).to_i} days ago)"
      roles = "`@\u200Beveryone`"
      unless mentioned.roles.empty?
        roles = ''
        mentioned.roles.each do |x|
          roles += x.name + ' '
        end
      end
      event << "Member of #{roles}"
      event << "User ID: #{mentioned.id}"
    end
  end
end
