module Bot::DiscordCommands
  # Displays bot information
  module Info
    include Bot
    extend Discordrb::Commands::CommandContainer
    command :info do |event|
      event << '**Malcolm-TRA**'
      event << 'https://github.com/TheOtherUnknown/Malcolm-TRA'
      event << 'Running commit: ' + `git rev-parse --short HEAD`.chomp
      event << "#{BOT.servers.length} servers"
      event << "Owner: #{BOT.user(configatron.owner).name}"
    end
  end
end
