task :install do
  sh 'bundle install --path vendor/bundle --binstubs'
  sh 'mv data/config-template.yaml data/config.yaml'
end

task :default do
  sh 'bundle exec ruby src/bot.rb'
end
