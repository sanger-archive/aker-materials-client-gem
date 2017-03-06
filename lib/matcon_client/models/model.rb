require 'json'

module MatconClient
  module Models
    class Model
      class_attribute :site,
                      :connection_class,
                      :connection_object,
                      :connection_options,
                      :endpoint

      self.connection_class     = Connection
      self.connection_options   = { :headers => { "Content-Type" => "application/json", "Accept" => "application/json" } }

      attr_reader :attributes

      def initialize(attributes = {})
        update_attributes(attributes)
      end

      def attributes
        @attributes ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      def to_json
        attributes.reject {|attr| attr[0] == '_' && attr != '_id' }.to_json
      end

      class << self

        def from_json(json)
          attributes = JSON.parse(json)
          new(attributes)
        end

        def connection(rebuild = false, &block)
          _build_connection(rebuild, &block)
          connection_object
        end

        protected

        def _build_connection(rebuild = false)
          return connection_object unless connection_object.nil? || rebuild
          self.connection_object = connection_class.new(connection_options.merge(site: site)).tap do |conn|
            yield(conn) if block_given?
          end
        end

      end

      private

      def update_attributes(attrs)
        return @attributes unless attrs.present?

        attrs.each do |key, value|
          send("#{key}=", value)
        end
      end

      def method_missing(method, *args, &block)
        normalized_method = method.to_s

        # If it contains an equals after some letter(s)...
        if normalized_method =~ /^(.*)=$/
          set_attribute($1, args.first)

        elsif has_attribute?(normalized_method)
          attributes[method]
        else
          super
        end

      end

      def set_attribute(name, value)
        attributes[name] = value
      end

      def has_attribute?(attribute)
        attributes.has_key?(attribute)
      end

    end
  end
end