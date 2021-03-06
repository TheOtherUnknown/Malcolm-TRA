module Bot::DiscordCommands
  # A trivia game module which pulls questions from data/trivia.db
  module Trivia
    extend Discordrb::Commands::CommandContainer
    command :trivia, min_args: 1, description: 'Trivia game management tool', usage: 'trivia [add|start|top]' do |event, action|
      game = TriviaGame.new(event)
      if game.channel_free?
        # Start a new game
        if action == 'start'
          event.respond('Starting trivia. The first to 5 points wins!')
          game.start(5)
        # Add a new question
        elsif (action == 'add') && event.user.on(event.server).permission?(:manage_channels)
          game.add_question
        elsif action == 'top' # Prints the top 5
          game.leaders
        end
      end
    end
  end
end
