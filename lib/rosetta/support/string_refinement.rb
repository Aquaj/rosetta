module Rosetta
  module Support
    refine String do
      def underscore
        self.scan(/[A-Z]+[a-z]*/).join('_').downcase
      end

      def camelize
        self.downcase
            .split('_')
            .map { |word| word[0].upcase + word[1..-1] }
            .join
      end

      def titleize
        self.downcase
            .split('_')
            .map { |word| word[0].upcase + word[1..-1] }
            .join(' ')
      end
    end
  end
end
