require 'rubygems'
require 'bundler/setup'
require 'cinch'
require 'dotenv'
Dotenv.load

require './hipchat_messenger'

REQUIRED_VARIABLES = %w{ HIPCHAT_API_TOKEN HIPCHAT_ROOM IRC_CHANNELS IRC_SERVER IRC_NICK }
REQUIRED_VARIABLES.each do |v|
  abort "Missing required environment variable: #{v}" unless ENV.has_key? v
end

hipchat = HipchatMessenger.new(ENV['HIPCHAT_API_TOKEN'], ENV['HIPCHAT_ROOM'])

cinchbot = Cinch::Bot.new do |bot|
  configure do |c|
    c.nick = c.user = ENV['IRC_NICK']
    c.server = ENV['IRC_SERVER']
    c.channels = ENV['IRC_CHANNELS'].split(';')
  end

  on :channel do |m|
    hipchat.message(m)
  end
end

cinchbot.start
