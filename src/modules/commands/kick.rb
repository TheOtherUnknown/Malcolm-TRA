module Bot::DiscordCommands
  # Kick a mentioned user from the server
  module KickUser
    extend Discordrb::Commands::CommandContainer
    command(:kick, description: 'Kick a user from the server.',
                   min_args: 1, required_permissions: [:kick_members], usage: 'kick <name>') do |event|
      mentions = event.message.mentions
      event.server.kick(mentions.first)
      'Done' unless mentions.first.nil? 
    end
  end
end
