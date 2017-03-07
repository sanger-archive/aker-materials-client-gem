require 'matcon_client/version'
require 'active_model'
require 'active_support/all'
require 'faraday'

module MatconClient
  autoload :Models,                  'matcon_client/models'
  autoload :Connection,              'matcon_client/connection'
  autoload :Query,                   'matcon_client/query'
  autoload :Requestor,               'matcon_client/requestor'
  autoload :Errors,                  'matcon_client/errors'
  autoload :Middleware,              'matcon_client/middleware'
  autoload :ResponseHandlerFactory,  'matcon_client/response_handler_factory'
  autoload :ResultSet,               'matcon_client/result_set'
end