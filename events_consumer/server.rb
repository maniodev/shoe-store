# frozen_string_literal: true

require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'redis'
require_relative 'lib/process_message'

EM.run do
  ws = Faye::WebSocket::Client.new(ENV['WEBSOCKET_URL'])
  redis = Redis.new(url: ENV['REDIS_URL'])

  ws.on :message do |event|
    message = JSON.parse(event.data)
    ProcessMessage.new(message, redis).call
  end
end
