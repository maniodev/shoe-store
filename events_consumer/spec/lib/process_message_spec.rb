# frozen_string_literal: true

require 'spec_helper'
require 'mock_redis'
require 'redis'
require './lib/process_message'

describe ProcessMessage do
  let(:redis) { MockRedis.new }
  let(:message) do
    {
      'store' => 'ALDO Ste-Catherine',
      'model' => 'ADERI',
      'inventory' => 10
    }
  end
  let(:key) { "#{message['store']}:#{message['model']}" }
  subject(:process_message) { described_class.new(message, redis).call }

  before do
    allow(Redis).to receive(:new).and_return(redis)
  end

  it 'saves the message to streams and sets' do
    process_message

    # ["1608827478450-0", {"inventory"=>"10", "model"=>"ADERI"}]
    expect(redis.xrange(key, '-',
                        '+')[0][1]).to eq({ 'inventory' => message['inventory'].to_s, 'model' => message['model'] })

    expect(redis.smembers('stores')).to eq [message['store']]
    expect(redis.smembers('shoes')).to eq [message['model']]
    expect(redis.hget('inventory', key)).to eq message['inventory'].to_s
  end
end
