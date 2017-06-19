require "spec_helper"
require "byebug"
describe MatconClient::Connection do
  let(:new_middleware) { double('fake middleware')}

  def has_middleware?(middleware)
    @connection.faraday.builder.handlers.include?(middleware)
  end


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

  describe '#use' do

    it 'adds middleware to the Faraday middleware stack' do
      @connection.use(new_middleware)
      expect(has_middleware?(new_middleware)).to eq(true)
    end

    context 'when the builder is locked' do
      before do
        allow(@connection.faraday.builder).to receive(:locked?).and_return(true)
      end
      it 'does not add middleware to the Faraday middleware stack' do
        @connection.use(new_middleware)
        expect(has_middleware?(new_middleware)).to eq(false)
      end
    end

  end

  describe '#delete' do

    before do
      @connection.use(new_middleware)
    end

    it 'deletes middleware from the Faraday middleware stack' do
      expect(has_middleware?(new_middleware)).to eq(true)
      @connection.delete(new_middleware)
      expect(has_middleware?(new_middleware)).to eq(false)
    end
  end
end
