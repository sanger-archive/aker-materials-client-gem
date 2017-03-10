require 'spec_helper'

describe MatconClient::ResultSet do

  let(:requestor) { double("Requestor") }
  let(:model) { instance_double("MatconClient::Material", requestor: requestor) }

  describe '#initialize' do
    it 'accepts a response and model' do
      response = double('Response')
      result_set = MatconClient::ResultSet.new(response: response, model: model)
      expect(result_set).to be_instance_of MatconClient::ResultSet
      expect(result_set.model).to be model
    end

    it 'has meta fields' do
      response = {
        _items: [],
         _meta: {
           max_results: 10,
           total: 15,
           page: 1,
        }
      }
      result_set = MatconClient::ResultSet.new(response: response, model: model)
      expect(result_set.max_results).to eq 10
      expect(result_set.total).to eq 15
      expect(result_set.page).to eq 1
    end

  end

  describe 'pagination' do

    describe '#has_next?' do

      context 'when _links has a next key' do
        it 'returns true' do
          response = {
            "_links": {
              "next": {
                  "href": "materials?page=2",
                  "title": "next page"
              }
            }
          }
          response_set = MatconClient::ResultSet.new(response: response, model: model)

          expect(response_set.has_next?).to be(true)
        end
      end

      context 'when _links does not have a next key' do
        it 'returns false' do
          response = {
            "_links": {}
          }

          response_set = MatconClient::ResultSet.new(response: response, model: model)
          expect(response_set.has_next?).to be(false)
        end
      end

    end

    describe '#has_prev?' do

      context 'when _links has a prev key' do
        it 'returns true' do
          response = {
            "_links": {
              "prev": {
                  "href": "materials?page=2",
                  "title": "previous page"
              }
            }
          }
          response_set = MatconClient::ResultSet.new(response: response, model: model)

          expect(response_set.has_prev?).to be(true)
        end
      end

      context 'when _links does not have a prev key' do
        it 'returns false' do
          response = {
            "_links": {}
          }

          response_set = MatconClient::ResultSet.new(response: response, model: model)
          expect(response_set.has_prev?).to be(false)
        end
      end

    end

    describe '#is_last?' do

      context 'when _links has a last key' do
        it 'returns false' do
          response = {
            "_links": {
              "last": {
                  "href": "materials?page=2",
                  "title": "last page"
              }
            }
          }
          response_set = MatconClient::ResultSet.new(response: response, model: model)

          expect(response_set.is_last?).to be(false)
        end
      end

      context 'when _links does not have a last key' do
        it 'returns true' do
          response = {
            "_links": {}
          }

          response_set = MatconClient::ResultSet.new(response: response, model: model)
          expect(response_set.is_last?).to be(true)
        end
      end

    end

    describe '#next' do
      it 'returns the next result set' do
        response = {
          "_links": {
            "next": {
                "href": "materials?page=2",
                "title": "next page"
            }
          }
        }
        response_set = MatconClient::ResultSet.new(response: response, model: model)

        expect(requestor).to receive(:get).with(nil, { query: "page=2" })

        response_set.next
      end
    end

    describe '#prev' do
      it 'returns the previous result set' do
        response = {
          "_links": {
            "prev": {
                "href": "materials?page=1",
                "title": "previous page"
            }
          }
        }
        response_set = MatconClient::ResultSet.new(response: response, model: model)

        expect(requestor).to receive(:get).with(nil, { query: "page=1" })

        response_set.prev
      end
    end

    describe '#last' do
      it 'returns the last page as a result set' do
        response = {
          "_links": {
            "last": {
                "href": "materials?page=10",
                "title": "last page"
            }
          }
        }
        response_set = MatconClient::ResultSet.new(response: response, model: model)

        expect(requestor).to receive(:get).with(nil, { query: "page=10" })

        response_set.last
      end
    end

  end

end