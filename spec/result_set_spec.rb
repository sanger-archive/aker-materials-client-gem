require 'spec_helper'

describe MatconClient::ResultSet do

  describe '#initialize' do
    it 'accepts a response and model' do
      response = double('Response')
      model = double('Model')
      result_set = MatconClient::ResultSet.new(response: response, model: model)
      expect(result_set).to be_instance_of MatconClient::ResultSet
      expect(result_set.model).to be model
    end

    it 'has meta fields' do
      model = double('Model')
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

end