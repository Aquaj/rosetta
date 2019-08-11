module Rosetta
  module Support
    refine String do
      def underscore
        self.scan(/[A-Z]+[a-z]*/).join('_').downcase
      end
    end
  end
end
