require 'twitter/arguments'
require 'twitter/direct_message'
require 'twitter/rest/utils'
require 'twitter/user'
require 'twitter/utils'

module Twitter
  module REST
    module DirectMessages
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns the 20 most recent direct messages sent to the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent to the authenticating user.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      def direct_messages_received(options = {})
        perform_get_with_objects('/1.1/direct_messages.json', options, Twitter::DirectMessage)
      end

      # Returns the 20 most recent direct messages sent by the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages/sent
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent by the authenticating user.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      def direct_messages_sent(options = {})
        perform_get_with_objects('/1.1/direct_messages/sent.json', options, Twitter::DirectMessage)
      end

      # Returns a direct message
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The requested messages.
      # @param id [Integer] A direct message ID.
      # @param options [Hash] A customizable set of options.
      def direct_message(id, options = {})
        options = options.dup
        options[:id] = id
        perform_get_with_object('/1.1/direct_messages/show.json', options, Twitter::DirectMessage)
      end

      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] The requested messages.
      # @overload direct_messages(options = {})
      #   Returns the 20 most recent direct messages sent to the authenticating user
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      # @overload direct_messages(*ids)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      # @overload direct_messages(*ids, options)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      #   @param options [Hash] A customizable set of options.
      def direct_messages(*args)
        arguments = Twitter::Arguments.new(args)
        if arguments.empty?
          direct_messages_received(arguments.options)
        else
          pmap(arguments) do |id|
            direct_message(id, arguments.options)
          end
        end
      end

      # Destroys direct messages
      #
      # @see https://dev.twitter.com/rest/reference/post/direct_messages/destroy
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Deleted direct message.
      # @overload destroy_direct_message(*ids)
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      # @overload destroy_direct_message(*ids, options)
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      #   @param options [Hash] A customizable set of options.
      def destroy_direct_message(*args)
        parallel_objects_from_response(Twitter::DirectMessage, :post, '/1.1/direct_messages/destroy.json', args)
      end

      # Sends a new direct message to the specified user from the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/post/direct_messages/new
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The sent message.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @param text [String] The text of your direct message, up to 10,000 characters.
      # @param options [Hash] A customizable set of options.
      def create_direct_message(user, text, options = {})
        options = options.dup
        merge_user!(options, user)
        options[:text] = text
        perform_post_with_object('/1.1/direct_messages/new.json', options, Twitter::DirectMessage)
      end

      # YF Changes Start
      # Documentation Pending
      def private_media(media_url)
        # Headers generated by Twitter::Headers don't work here for some reason. Switching to SimpleAuth.
        # See: https://twittercommunity.com/t/dm-media-download-results-in-redirection-loop/95301
        auth_header = SimpleOAuth::Header.new(
          'GET',          # method
          media_url, # url
          {},             # params
          {               # options
            consumer_key: self.consumer_key,
            consumer_secret: self.consumer_secret,
            token: self.access_token,
            token_secret: self.access_token_secret
          }
        )

        response = Faraday.get do |req|
          req.url(media_url)
          req.headers['Authorization'] = auth_header.to_s
        end

        if response.success?
          StringIO.new(response.body.force_encoding('UTF-8'))
        else
          false
        end
      end

      # Documentation Pending
      def send_direct_message(message_data = {})
        auth_header = Twitter::Headers.new(self, :post, 'https://api.twitter.com/1.1/direct_messages/events/new.json')

        response = Faraday.post do |req|
          req.url('https://api.twitter.com/1.1/direct_messages/events/new.json')
          req.headers['Authorization'] = auth_header.oauth_auth_header.to_s
          req.headers['Content-Type'] = 'application/json'
          req.body = message_data.to_json
        end

        if response.success?
          JSON.parse(response.body)['event']['id'] # Return twitter message id
        else
          false
        end
      end
      # YF Changes End

      alias d create_direct_message
      alias m create_direct_message
      alias dm create_direct_message
    end
  end
end
