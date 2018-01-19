# Malcolm

This is a Discord bot build specifically for The Ranger's Apprentice server using meew0's [discordrb](https://github.com/meew0/discordrb).

The original gemstone template can be found on [GitHub](https://github.com/z64/gemstone).
## Setup

This bot may not work for other servers. However, here are the install directions:
1. Clone or download this repo
2. `gem install bundler` and `gem install rake` unless you already have them
3. `rake install` to install deps 

Follow steps in the next section to configure your bot and do a first-time run.

## Configuring and running your bot

Make a copy of config-template.yaml and rename it to `config.yaml` *exactly*.

Fill out each field provided to set up a minimal discord bot, with a few commands and an event to get you started.

To run your bot, open your terminal and run `rake` in the top level folder of your bot. You're free to make something like a bash script, or Windows batch file that will do this for you at the click of an icon. You can also do other things before running your bot this way.

## Adding commands and events

Following `discordrb`'s [documentation](http://www.rubydoc.info/gems/discordrb), adding new commands and events is "easy"

### Adding a command

Create a new `*.rb` file here for your command: `/src/modules/commands/my_command.rb`

Start with the following structure, and fill in whatever you would like that command to do, following `discordrb`'s documenation:

```ruby
module Bot::DiscordCommands
  # Document your command
  module MyCommand
    extend Discordrb::Commands::CommandContainer
    command :my_command do |event|
      # do discord things!
    end
  end
end
```

Save the file, and start the bot. The new command file will be detected and added into the bot automatically.

### Adding an event

Create a new `*.rb` file here for your command: `/src/modules/events/my_event.rb`

Start with the following structure, and fill in whatever you would like that command to do, following `discordrb`'s documenation:

```ruby
module Bot::DiscordEvents
  # Document your event 
  module MyEvent
    extend Discordrb::EventContainer
    member_join do |event|
      # do discord things!
    end
  end
end
```

Save the file, and start the bot. The new event file will be detected and added into the bot automatically.

## Checking style with rubocop

Install rubocop.

`gem install rubocop`

In the top level folder, run:

`rubocop`
