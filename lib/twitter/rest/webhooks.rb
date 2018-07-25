# Added By YF, Documentation Pending
#
require 'twitter/headers'
require 'faraday'

module Twitter
  module REST
    module Webhooks
      def subscribe_to_webhooks
        auth_header = Twitter::Headers.new(self, :post, 'https://api.twitter.com/1.1/account_activity/all/envlogicalware/subscriptions.json')

        response = Faraday.post do |req|
          req.url('https://api.twitter.com/1.1/account_activity/all/envlogicalware/subscriptions.json')
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
        end

        response.status == 204
      end

      def unsubscribe_from_webhooks
        auth_header = Twitter::Headers.new(self, :delete, 'https://api.twitter.com/1.1/account_activity/all/envlogicalware/subscriptions.json')

        response = Faraday.delete do |req|
          req.url('https://api.twitter.com/1.1/account_activity/all/envlogicalware/subscriptions.json')
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
        end
        response.status == 204
      end
    end
  end
end
