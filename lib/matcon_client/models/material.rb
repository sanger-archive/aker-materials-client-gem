require 'ostruct'
require 'json'

module MatconClient
  module Models
    class Material

      attr_reader :attributes

      def initialize(attributes = {})
        @attributes ||= ActiveSupport::HashWithIndifferentAccess.new

        return @attributes unless attributes.present?

        attributes.each do |key, value|
          send("#{key}=", value)
        end
      end

      def self.from_json(json)
        attributes = JSON.parse(json)
        new(attributes)
      end

      def to_json
        attributes.to_json
      end

      private

      def method_missing(method, *args, &block)
        normalized_method = method.to_s

        # If it contains an equals after some letter...
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