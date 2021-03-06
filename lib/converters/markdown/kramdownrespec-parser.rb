# Frozen-string-literal: true

module Jekyll
  module Converters
    class Markdown
      class KramdownRespecParser < KramdownParser

        def initialize(config)
          # super
          unless defined?(KramdownRespec)
            Jekyll::External.require_with_graceful_fail "kramdown-respec"
          end
          @main_fallback_highlighter = config["highlighter"] || "rouge"
          @config = config["kramdown-respec"] || {}
          @highlighter = nil
          # setup
        end

        def convert(content)
          document = Kramdown::Document.new(content, @config)
          html_output = document.to_html
          if @config["show_warnings"]
            document.warnings.each do |warning|
              Jekyll.logger.warn "Kramdown warning:", warning
            end
          end
          html_output
        end

        private
        # rubocop:disable Performance/HashEachMethods
        def make_accessible(hash = @config)
          hash.keys.each do |key|
            hash[key.to_sym] = hash[key]
            make_accessible(hash[key]) if hash[key].is_a?(Hash)
          end
        end
        # rubocop:enable Performance/HashEachMethods

        # config[kramdown][syntax_higlighter] >
        #   config[kramdown][enable_coderay] >
        #   config[highlighter]
        # Where `enable_coderay` is now deprecated because Kramdown
        # supports Rouge now too.

        private
        def highlighter
          return @highlighter if @highlighter

          if @config["syntax_highlighter"]
            return @highlighter = @config[
              "syntax_highlighter"
            ]
          end

          @highlighter = begin
            if @config.key?("enable_coderay") && @config["enable_coderay"]
              Jekyll::Deprecator.deprecation_message(
                "You are using 'enable_coderay', " \
                "use syntax_highlighter: coderay in your configuration file."
              )

              "coderay"
            else
              @main_fallback_highlighter
            end
          end
        end

        private
        def strip_coderay_prefix(hash)
          hash.each_with_object({}) do |(key, val), hsh|
            cleaned_key = key.to_s.gsub(%r!\Acoderay_!, "")

            if key != cleaned_key
              Jekyll::Deprecator.deprecation_message(
                "You are using '#{key}'. Normalizing to #{cleaned_key}."
              )
            end

            hsh[cleaned_key] = val
          end
        end

        # If our highlighter is CodeRay we go in to merge the CodeRay defaults
        # with your "coderay" key if it's there, deprecating it in the
        # process of you using it.

        private
        def modernize_coderay_config
          unless @config["coderay"].empty?
            Jekyll::Deprecator.deprecation_message(
              "You are using 'kramdown.coderay' in your configuration, " \
              "please use 'syntax_highlighter_opts' instead."
            )

            @config["syntax_highlighter_opts"] = begin
              strip_coderay_prefix(
                @config["syntax_highlighter_opts"] \
                  .merge(CODERAY_DEFAULTS) \
                  .merge(@config["coderay"])
              )
            end
          end
        end
      end
    end
  end
end
