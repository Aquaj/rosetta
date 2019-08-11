module Rosetta
  module Support
    refine String do
      def underscore
        case_components.map(&:downcase).join('_')
      end

      def camelize
        case_components.map(&:capitalize).join
      end

      def titleize
        case_components.map(&:capitalize).join(' ')
      end

      def capitalize
        self[0].upcase + self[1..-1].downcase
      end

      def case_components
        full_caps_word = "[A-Z0-9]+(?![a-z])"
        titlecase_word = "[A-Z0-9][a-z0-9]*"
        lowercase_word = "(?!<[A-Z0-9])[a-z0-9]*"
        separator      = "[\w_-]"
        word           = "(#{full_caps_word})|(#{titlecase_word}|(#{lowercase_word})"
        components     = self.scan(/(?:#{word})#{separator}?)/)

        # HACK: Removing scan weirdness... there's probably a better way to do
        # this. Maybe stringscanner ?
        components.map { |component| component.reject { |e| e == '' || e.nil? }.uniq }.flatten
      end
    end
  end
end
