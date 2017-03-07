require 'spec_helper'

describe MatconClient::ResultSet do

  describe '#initialize' do
    it 'accepts a response' do
      response = double('Response')
      result_set = MatconClient::ResultSet.new(response: response)
      expect(result_set).to be_instance_of MatconClient::ResultSet
    end
  end

end