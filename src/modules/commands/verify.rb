# Create ratelimiting bucket
BOT.bucket :wait60, delay: 60
module Bot::DiscordCommands
  # Allow a user to verify themself after certian conditions are met
  module Verify
    extend Discordrb::Commands::CommandContainer
    command :verify, bucket: :wait60, description: 'Add yourself to the \"Verified\" role.', required_permissions: [:manage_roles], usage: 'verify' do |event|
      jointime = event.user.on(event.server).joined_at
      if jointime.mon > Time.now.mon || Time.now.mday - jointime.mday > 3 || jointime.year < Time.now.year
        allroles = event.server.roles
        allroles.each do |a|
          if configatron.verified.casecmp(a.name).zero?
            event.user.on(event.server).add_role(a)
            break
          end
        end
      else
        'You do not qualify for autoverify. Check back later.'
      end
    end
  end
end
