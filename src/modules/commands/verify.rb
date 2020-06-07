module Bot::DiscordCommands
  # Allow a user to verify themself after certian conditions are met
  module Verify
    extend Discordrb::Commands::CommandContainer
    command :verify, bucket: :wait90, description: 'Add yourself to the \"Verified\" role.', usage: 'verify' do |event|
      joindate = event.user.on(event.server).joined_at
      if event.user.permission?(:change_nickname)
        'You\'re already verified.'
      elsif joindate.nil? # API problems
        'Failed to verify, could not get join date'
      # User must be in the server at least 1 day
      elsif (Time.now.utc - joindate).to_i >= 86_400
        allroles = event.server.roles
        # Loop through all server roles to find role named in config.rb
        allroles.each do |a|
          next unless configatron.verified.casecmp(a.name).zero?

          event.user.on(event.server).add_role(a)
          event.message.react('✅')
          break
        end
      else
        'You do not qualify for autoverify or it is not enabled. Check back later.'
      end
    end
  end
end
