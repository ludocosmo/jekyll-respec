# frozen_string_literal: true

require 'jekyll/converters/markdown'

module Jekyll
  module Converters
    # Markdown converter.
    # For more info on converters see https://jekyllrb.com/docs/plugins/converters/
    class Markdown < Converter

      # Rubocop does not allow reader methods to have names starting with `get_`
      # To ensure compatibility, this check has been disabled on this method
      #
      # rubocop:disable Naming/AccessorMethodName
      def get_processor
        case @config["markdown"].downcase
        when "redcarpet" then return RedcarpetParser.new(@config)
        when "kramdown"  then return KramdownParser.new(@config)
        when "rdiscount" then return RDiscountParser.new(@config)
        when "kramdown-respec" then KramdownRespecParser.new(@config)
        else
          custom_processor
        end
      end

      # Public: Provides you with a list of processors, the ones we
      # support internally and the ones that you have provided to us (if you
      # are not in safe mode.)

      def valid_processors
        %w(rdiscount kramdown kramdown-respec redcarpet) + third_party_processors
      end

    end
  end
end