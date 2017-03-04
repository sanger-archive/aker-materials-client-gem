require 'matcon_client/version'
require 'active_model'
require 'active_support/all'
require 'faraday'

module MatconClient
  autoload :Models, 'matcon_client/models'
  autoload :Connection, 'matcon_client/connection'
  autoload :Query, 'matcon_client/query'
end
