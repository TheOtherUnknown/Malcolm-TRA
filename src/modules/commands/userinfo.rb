module Bot::DiscordCommands
  # Document your command
  module UserInfo
    extend Discordrb::Commands::CommandContainer
    include Bot
    command :userinfo, description: 'Shows basic user information', usage: 'userinfo <user or ID>' do |event, uid|
      user = event.user.on(event.server) # If all else fails, just use the user who gave the command
      if event.message.mentions.empty? && !uid.nil? # Resolve a user ID
        user = BOT.user(uid.to_i)
        return 'User ID lookup failed.' if user.nil?

        user = user.on(event.server)
      elsif !event.message.mentions.empty? # Resolve a user mention
        user = event.message.mentions.first.on(event.server)
      end
      # Escape markdown in usernames
      nick = "**#{user.name.gsub(/[_*~]/, '_' => '\_', '*' => '\*', '~' => '\~')}##{user.discrim}**"
      nick += '👑' if user.owner? # Add crown after nick if owner
      nick += '🛡️' if user.permission?(:kick_members) # Add shield after nick if user can kick
      nick += '🤖' if user.current_bot? # Add robot to nick if bot
      event << nick
      begin
        retryTimes ||= 0
        event << user.joined_at.strftime('Joined on %B %e, %Y at %l:%M %p UTC ') + "(#{((Time.now - user.joined_at) / 86_400).to_i} days ago)"
      rescue NoMethodError # IF we did not recieve the join event from the API, refresh the cache once
        if (retryTimes += 1) < 2
          Bot::BOT.init_cache
          retry
        end
        event << 'Join date unknown'
      end
      roles = "`@\u200Beveryone`"
      unless user.roles.empty?
        roles = ''
        user.roles.each do |x|
          roles += '`' + x.name + '` '
        end
      end
      event << "Member of #{roles}"
      event << "User ID: #{user.id}"
    end
  end
end
