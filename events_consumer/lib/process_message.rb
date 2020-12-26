# frozen_string_literal: true

class ProcessMessage
  attr_reader :message, :key, :client

  def initialize(message, client)
    @key = "#{message['store']}:#{message['model']}"
    @message = message
    @client = client
  end

  def call
    # stream
    client.xadd(key, { model: message['model'], inventory: message['inventory'] })

    # stores
    client.sadd('stores', message['store'])

    # shoes
    client.sadd('shoes', message['model'])

    # inventory
    client.hset('inventory', key, message['inventory'])
  end
end
