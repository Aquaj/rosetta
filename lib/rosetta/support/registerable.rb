require 'rosetta/exceptions'

module Rosetta
  module Support
    module Registerable
      def registerable_as(nature)
        @registered = {}

        class << self
          attr_reader :registered

          def [](key)
            registered[key]
          end
        end

        define_singleton_method :register do |name, object=nil, &block|
          #TODO: Feels clunky, string refinement maybe?
          nature_words = nature.to_s.downcase
                               .split('_')
                               .map { |word| word[0].upcase + word[1..-1] }

          camel_nature = nature_words.join
          human_nature = nature_words.join(' ')

          error_name = "Existing#{camel_nature}Error"
          error_class = if constants.include?(error_name)
                          const_get(error_name)
                        else
                          RegistrationError
                        end
          raise error_class, <<-ERROR.strip if @registered.key? name
            #{human_nature} #{name} is already registered.
          ERROR

         if object && block
           raise ArgumentError, "Can't take both #{human_nature.downcase} object and block."
         end
          @registered[name] = object
        end
      end
    end
  end
end
