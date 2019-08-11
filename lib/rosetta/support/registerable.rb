require 'rosetta/exceptions'
require 'rosetta/support'

module Rosetta
  module Support
    module Registerable
      using Rosetta::Support

      def registerable_as(nature)
        @registered = {}

        class << self
          attr_reader :registered

          def [](key)
            registered[key]
          end
        end

        define_singleton_method :register do |name, object=nil, &block|
          nature = nature.to_s
          error_name = :"Existing#{nature.camelize}Error"
          error_class = if constants.include?(error_name)
                          const_get(error_name)
                        else
                          RegistrationError
                        end
          raise error_class, <<-ERROR.strip if @registered.key? name
            #{nature.titleize} #{name} is already registered.
          ERROR

         if object && block
           raise ArgumentError, "Can't take both #{nature.downcase} object and block."
         end
          @registered[name] = object || block
        end
      end
    end
  end
end
