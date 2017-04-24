require "spec_helper"

describe MatconClient::Middleware::Status do

  before do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/not_authorized') { |env| [401, {}, 'monkey'] }
      stub.get('/bad_request') { |env| [400, {}, 'monkey'] }
      stub.get('/access_denied') { |env| [403, {}, 'monkey'] }
      stub.get('/not_found') { |env| [404, {}, 'monkey'] }
      stub.get('/conflict') { |env| [409, {}, 'monkey'] }
      stub.get('/unprocessable_entity') { |env| [422, {}, 'monkey'] }
      stub.get('/server_error') { |env| [500, {}, 'monkey'] }
      stub.get('/unexpected_status') { |env| ['whaaaaat', {}, 'monkey'] }
    end

    @connection = Faraday.new do |builder|
      builder.use MatconClient::Middleware::Status
      builder.adapter :test, stubs
    end
  end

  it 'raises Errors::NotAuthorized when status is 401' do
    expect { @connection.get '/not_authorized' }.to raise_error(MatconClient::Errors::NotAuthorized)
  end

  it 'raises Errors::BadRequest when status is 400' do
    expect { @connection.get '/bad_request' }.to raise_error(MatconClient::Errors::BadRequest)
  end

  it 'raises Errors::AccessDenied when status is 403' do
    expect { @connection.get '/access_denied' }.to raise_error(MatconClient::Errors::AccessDenied)
  end

  it 'raises Errors::NotFound when status is 404' do
    expect { @connection.get '/not_found' }.to raise_error(MatconClient::Errors::NotFound)
  end

  it 'raises Errors::Conflict when status is 409' do
    expect { @connection.get '/conflict' }.to raise_error(MatconClient::Errors::Conflict)
  end

  it 'raises Errors::UnprocessableEntity when status is 422' do
    expect { @connection.get '/unprocessable_entity' }.to raise_error(MatconClient::Errors::UnprocessableEntity)
  end

  it 'raises Errors::ServerError when status is 500' do
    expect { @connection.get '/server_error' }.to raise_error(MatconClient::Errors::ServerError)
  end

  it 'raises Errors::UnexpectedStatus when status not recognised' do
    expect { @connection.get '/unexpected_status' }.to raise_error(MatconClient::Errors::UnexpectedStatus)
  end

end