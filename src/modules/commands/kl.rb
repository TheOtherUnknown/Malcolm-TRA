module Bot::DiscordCommands
  # Issues a ban (K-line) based on user ID
  module KillLine
    extend Discordrb::Commands::CommandContainer
    include Bot
    command :kl, description: 'Ban a user via user ID.', min_args: 1, required_permissions: [:ban_members], usage: 'kl ID' do |_event, uid|
      uid = BOT.user(uid.to_i)
      return 'Unable to lookup user' if uid.nil?

      event.user.ban(uid)
    end
  end
end
