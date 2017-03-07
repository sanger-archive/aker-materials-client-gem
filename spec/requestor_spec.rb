require "spec_helper"

describe MatconClient::Requestor do

  let(:connection) { double("Connection") }
  let(:result_set) { double("Result Set") }
  let(:some_json)  { { some: 'json'}.to_json }

  let(:klass) do
    double("Material", connection: connection, result_set: result_set, endpoint: 'materials')
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
      expect(result_set).to receive(:build).with(some_json)
      requestor.get('materials')
    end

    context 'when called with query params' do
      it 'calls connection#run with the query params in the path' do
        expect(connection).to receive(:run).with(:get, 'materials?test=foo', {}, {}).and_return(some_json)
        expect(result_set).to receive(:build).with(some_json)
        requestor.get('materials', query: 'test=foo')
      end
    end

  end

  describe '#post' do

    it 'calls connection#run with post' do
      expect(connection).to receive(:run).with(:post, 'materials', { body: { monkey: 'news' } }, {})
                                         .and_return(some_json)

      expect(result_set).to receive(:build).with(some_json)
      requestor.post('materials', body: { monkey: 'news' })
    end
  end

  describe '#put' do

    it 'calls connection#run with put' do
      expect(connection).to receive(:run).with(:put, 'materials', { body: { monkey: 'news' } }, {})
                                         .and_return(some_json)

      expect(result_set).to receive(:build).with(some_json)
      requestor.put('materials', body: { monkey: 'news' })
    end
  end

  describe '#delete' do

    it 'calls connection#run with delete' do
      expect(connection).to receive(:run).with(:delete, 'materials/1234-1234-1234-1234', {}, {})
                                         .and_return(some_json)

      expect(result_set).to receive(:build).with(some_json)
      requestor.delete('materials/1234-1234-1234-1234')
    end

  end

end