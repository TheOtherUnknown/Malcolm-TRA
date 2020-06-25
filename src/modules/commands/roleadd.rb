module Bot::DiscordCommands
  # Adds custom roles via command
  module MyCommand
    extend Discordrb::Commands::CommandContainer
    command(:roleadd, min_args: 1, description: 'Grants you a custom role', usage: 'roleadd <role name>') do |event, nrole|
      event.server.roles.each do |role|
        if nrole.casecpm?(role) && role.permissions.bits.zero? # Doesthe role exist, and does it have no permissions?
          nrole = role
          break
        end
      end
      if nrole.is_a?(Discordrb::Role)
        event.user.roles.each do |role| # You can only have 1 role, so remove the others
          event.user.remove_role(role) if role.permissions.bits.zero?
        end
        event.user.add_role(nrole)
        event.message.react('✅')
      else
        event.respond("Cannot find role #{nrole}!")
      end
    end
  end
end
