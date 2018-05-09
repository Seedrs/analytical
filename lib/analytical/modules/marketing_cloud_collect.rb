module Analytical
  module Modules
    class MarketingCloudCollect
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          <<-HTML
            <!-- Analytical Init: MarketingCloudCollect -->
            <script src="http://#{options[:key]}.collect.igodigital.com/collect.js"></script>
            <script>
              _etmc.push(["setOrgId", "#{options[:key]}"]);
            </script>
          HTML
        end
      end

      def track(*args) # page, options
        <<-JS.gsub(/^ {10}/, '')
          if (typeof _etmc === 'object') {
            _etmc.push(["trackPageView"]);
          }
        JS
      end

      def identify(*args) # id, options
        <<-JS.gsub(/^ {10}/, '')
          if (options && options.email) {
            _etmc.push(["setUserInfo", { "email": options.email }]);
          }
        JS
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          _etmc.push(["trackEvent", { "name": name, "details": options }]);
        JS
      end
    end
  end
end
