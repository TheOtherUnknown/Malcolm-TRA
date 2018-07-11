module Bot::DiscordCommands
  # A Russian roulette style game that might just get you kicked
  module RussianRoulette
    extend Discordrb::Commands::CommandContainer
    command :rr, description: 'A simple game of daring. Danger! Danger Will Robinson!', usage: 'rr' do |event|
      if (defined? @gun).nil? || @gun.empty?
        @gun = Array.new(5, false)
        @gun[rand(5)] = true
      end
      chamber = rand(@gun.length - 1)
      if @gun[chamber]
        begin
        event.server.kick(event.user)
        @gun.clear
        '**BANG!**'
        rescue Discordrb::Errors::NoPermission
          event.channel.send('Well that takes the fun out of things. No kick permissions.')
          @gun.clear
        end
      else
        @gun.delete_at(chamber)
        'Click.'
      end
    end
  end
end
