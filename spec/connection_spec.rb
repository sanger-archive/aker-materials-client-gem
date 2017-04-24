require "spec_helper"

describe MatconClient::Connection do

  before(:each) do
    @connection = MatconClient::Connection.new(site: 'http://monkey.news')
  end

  it 'builds a Faraday connection on initialization' do
    expect(@connection.faraday).to be_kind_of(Faraday::Connection)
  end

  describe '#run' do

    it 'sends a method to Faraday' do
      expect(@connection.faraday).to receive(:get).with('stories', { type: 'fascinating' }, {})
      @connection.run(:get, 'stories', type: 'fascinating')
    end

  end

  # TODO: I can't figure out how to test what Middleware Faraday currently has in its stack
  describe '#use' do

    it 'adds middleware to the Faraday middleware stack'

    context 'when the builder is locked' do
      it 'does\'t add middleware to the Faraday middleware stack'
    end

  end

  describe '#delete' do
    it 'deletes middleware from the Faraday middleware stack'
  end

end