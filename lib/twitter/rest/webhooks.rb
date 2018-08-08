# Added By YF, Documentation Pending
#
require 'twitter/headers'
require 'faraday'

module Twitter
  module REST
    module Webhooks
      def subscribe_to_webhooks(env_name)
        auth_header = Twitter::Headers.new(self, :post, "https://api.twitter.com/1.1/account_activity/all/#{env_name}/subscriptions.json")

        response = Faraday.post do |req|
          req.url('https://api.twitter.com/1.1/account_activity/all/#{env_name}/subscriptions.json')
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
        end

        response.status == 204
      end

      def unsubscribe_from_webhooks(env_name)
        auth_header = Twitter::Headers.new(self, :delete, "https://api.twitter.com/1.1/account_activity/all/#{env_name}/subscriptions.json")

        response = Faraday.delete do |req|
          req.url('https://api.twitter.com/1.1/account_activity/all/#{env_name}/subscriptions.json')
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
        end
        response.status == 204
      end

      def unsubscribe_from_old_webhooks
        auth_header = Twitter::Headers.new(self, :delete, "https://api.twitter.com/1.1/account_activity/webhooks/#{webhook_id}/subscriptions.json")

        response = Faraday.delete do |req|
          req.url("https://api.twitter.com/1.1/account_activity/webhooks/#{webhook_id}/subscriptions.json")
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
        end
        response.status == 204
      end

      private

      def webhook_id
        auth_header = Twitter::Headers.new(self, :get, 'https://api.twitter.com/1.1/account_activity/webhooks.json').oauth_auth_header.to_s

        # Returns array of registered webhooks
        response = Faraday.get do |req|
          req.url('https://api.twitter.com/1.1/account_activity/webhooks.json')
          req.headers['Authorization'] = auth_header
        end

        JSON.parse(response.body).first['id'] # Only one webhook is allowed by default
      end
    end
  end
end
