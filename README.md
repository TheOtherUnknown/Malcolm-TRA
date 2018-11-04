# Malcolm
[![Build Status](https://travis-ci.com/TheOtherUnknown/Malcolm-TRA.svg?branch=master)](https://travis-ci.com/TheOtherUnknown/Malcolm-TRA)

This is a Discord bot build specifically for The Ranger's Apprentice server using meew0's [discordrb](https://github.com/meew0/discordrb).

The original gemstone template can be found on [GitHub](https://github.com/z64/gemstone).
## Setup

This bot has not been extensively tested outside of the Ranger's Apprentice server. If odd behaviour occurs, please report it.
0. Have or install a ruby version >= 2.4.0
1. Clone this repo
2. `gem install bundler` and `gem install rake` unless you already have them
3. `bundle install` to install deps 

Follow steps in the next section to configure your bot and do a first-time run.

## Configuring and running your bot

Make a copy of `example.config.rb` and rename it to `config.rb` *exactly*.

Fill out each field provided to set up a Malcolm's configuration. The gaming field is optional.

To run your bot, open your terminal and run `rake` in the top level folder of your bot. You're free to make something like a bash script, or Windows batch file that will do this for you at the click of an icon. You can also do other things before running your bot this way.

[Development server](https://discord.gg/fCr9U29)


To contribute, see the [Developer](https://github.com/TheOtherUnknown/Malcolm-TRA/wiki/Development) wiki page.
