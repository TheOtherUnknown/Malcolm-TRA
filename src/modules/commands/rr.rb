module Bot::DiscordCommands
  # A Russian roulette style game that might just get you kicked
  module RussianRoulette
    extend Discordrb::Commands::CommandContainer
    dead = {} # Contains game losers. USERID -> Time of loss
    dead.default = 86_400
    command :rr, description: 'A simple game of daring. Danger! Danger Will Robinson!', usage: 'rr' do |event|
      if (defined? @gun).nil? || @gun.empty?
        @gun = Array.new(5, false)
        @gun[rand(5)] = true
      end
      # Only allow a user to play if they haven't lost today
      if (Time.now - dead[event.user.id]).to_i < 86_400
        'You died! Try again tomorrow.'
      else
        chamber = rand(@gun.length - 1)
        if @gun[chamber]
          begin
            dead[event.user.id] = Time.now
            event.server.kick(event.user)
            @gun.clear
            '**BANG!**'
          rescue Discordrb::Errors::NoPermission
            @gun.clear
            'Well that takes the fun out of things. No kick permissions.'
          end
        else
          @gun.delete_at(chamber)
          'Click.'
        end
      end
    end
  end
end
