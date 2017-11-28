require "spec_helper"
require 'pry'
describe MatconClient::Requestor do

  let(:connection) { double("Connection") }
  let(:response_handler) { double("Response handler") }
  let(:some_json) { instance_double("Faraday::Response", body: { some: 'json'}) }

  let(:klass) do
    double("Material", connection: connection, response_handler: response_handler, endpoint: 'materials')
  end

  let(:requestor) { MatconClient::Requestor.new(klass: klass) }

  describe '#initialize' do

    it 'sets klass' do
      expect(requestor.klass).to eq(klass)
    end

  end

  describe '#get' do

    it 'calls connection#run with get' do
      expect(connection).to receive(:run).with(:get, 'materials', {}, {}).and_return(some_json)
      expect(response_handler).to receive(:build).with(some_json, nil)
      requestor.get()
    end

    context 'when called with query params' do
      it 'calls connection#run with the query params in the path' do
        expect(connection).to receive(:run).with(:get, 'materials?test=foo', {}, {}).and_return(some_json)
        expect(response_handler).to receive(:build).with(some_json, nil)
        requestor.get(nil, query: 'test=foo')
      end
    end

  end

  describe '#post' do

    it 'calls connection#run with post' do
      expect(connection).to receive(:run).with(:post, 'materials', { body: { monkey: 'news' } }, {})
                                         .and_return(some_json)

      expect(response_handler).to receive(:build).with(some_json, nil)
      requestor.post(nil, body: { monkey: 'news' })
    end
  end

  describe '#put' do

    it 'calls connection#run with put' do
      expect(connection).to receive(:run).with(:put, 'materials', { body: { monkey: 'news' } }, {})
                                         .and_return(some_json)

      expect(response_handler).to receive(:build).with(some_json, nil)
      requestor.put(nil, body: { monkey: 'news' })
    end
  end

  describe '#delete' do
    it 'calls connection#run with delete' do
      expect(connection).to receive(:run).with(:delete, 'materials/123', {}, {})
                  .and_return(some_json)
      expect(response_handler).to receive(:build).with(some_json, nil)
      requestor.delete('123')
    end
  end

end