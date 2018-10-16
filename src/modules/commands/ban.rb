module Bot::DiscordCommands
  # Ban a user from the server, deleting no messages
  module KickbanUser
    extend Discordrb::Commands::CommandContainer
    command(:kb, description: 'Ban a user from the server.', min_args: 1, required_permissions: [:ban_members], usage: 'kb user') do |event|
      mentions = event.message.mentions
      event.server.ban(mentions.first)
      'Not a valid user!' if mentions.first.nil?
    end
  end
end
