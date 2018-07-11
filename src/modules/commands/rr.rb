module Bot::DiscordCommands
  # A Russian roulette style game that might just get you kicked
  module RussianRoulette
    extend Discordrb::Commands::CommandContainer
    command :rr, description: 'A simple game of daring.', usage: 'rr' do |event|
      if rand(1..6) == 1
        event.server.kick(event.user)
        '*BANG!*'
      else
        'Click.'
      end
    end
  end
end
