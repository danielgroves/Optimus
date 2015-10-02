task :rack do
  `bundle exec rackup app/config.ru`
end

task :test do
  puts `rubocop`
  puts `bundle exec rspec spec/`
end
