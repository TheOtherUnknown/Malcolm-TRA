module Bot::DiscordCommands
  # Returns a Bastard Operator from Hell excuse
  # Credit to Jeff Ballard http://pages.cs.wisc.edu/~ballard/bofh/
  module Bofh
    extend Discordrb::Commands::CommandContainer
    command :bofh, description: 'Returns a BOfH style excuse.' do |event|
      begin
        list = File.open('data/excuses.txt', 'r').readlines
      rescue IOError
        event.respond('Unable to open excuse file! Check that the file is readable and exists.')
      end
      event.respond(list[rand(list.length)])
    end
  end
end
