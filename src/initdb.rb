# Creates the santa.db sqlite3 database as required by the bot's santa module
require 'sqlite3'
puts 'Attempting to create a new SQLite3 database for secret santa'
puts 'Danger! Danger! If the data/santa.db file already exists, it will be overwritten. All data will be lost!'
puts 'To continue, enter \"destroy\", or anything else to quit:'
if gets.chomp == 'destroy'
  db = SQLite3::Database.new('../data/santa.db')
  begin
   db.execute('DROP TABLE IF EXISTS users')
   db.execute('CREATE TABLE users ( rid integer PRIMARY KEY AUTOINCREMENT, username text, uid text, pref text, other text, giving text, matched text NOT NULL DEFAULT 0 )')
  rescue SQLite3::ReadOnlyException
    puts 'Database is read-only, please adjust your permissions'
  rescue StandardError => e
    puts 'An unexpected error occured!'
    puts e
  else
    puts 'Database created successfully'
 end
end
