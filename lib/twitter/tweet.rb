require 'twitter/creatable'
require 'twitter/entities'
require 'twitter/identity'

module Twitter
  class Tweet < Twitter::Identity
    include Twitter::Creatable
    include Twitter::Entities
    # @return [String]
    attr_reader :filter_level, :in_reply_to_screen_name, :lang, :source, :text
    # @return [Integer]
    attr_reader :favorite_count, :in_reply_to_status_id, :in_reply_to_user_id,
                :quote_count, :reply_count, :retweet_count
    # @return [Hash] 24.07.2018 LM changes
    attr_reader :extended_tweet
    alias in_reply_to_tweet_id in_reply_to_status_id
    alias reply? in_reply_to_user_id?
    object_attr_reader :GeoFactory, :geo
    object_attr_reader :Metadata, :metadata
    object_attr_reader :Place, :place
    object_attr_reader :Tweet, :retweeted_status
    object_attr_reader :Tweet, :quoted_status
    object_attr_reader :Tweet, :current_user_retweet
    alias retweeted_tweet retweeted_status
    alias retweet? retweeted_status?
    alias retweeted_tweet? retweeted_status?
    alias quoted_tweet quoted_status
    alias quote? quoted_status?
    alias quoted_tweet? quoted_status?
    object_attr_reader :User, :user, :status
    predicate_attr_reader :favorited, :possibly_sensitive, :retweeted,
                          :truncated

    # @note May be > 280 characters.
    # @return [String]
    # 24.07.2018 LM changes, check if tweet truncated and get extended_tweet
    def full_text
      tweet_text = truncated? ? extended_tweet[:full_text] : text
      if retweet?
        prefix = tweet_text[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]
        retweet_text = retweeted_status.truncated? ? retweeted_status.extended_tweet[:full_text] : retweeted_status.text
        [prefix, retweet_text].compact.join
      else
        tweet_text
      end
    end
    memoize :full_text

    # @return [Addressable::URI] The URL to the tweet.
    def uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/status/#{id}") if user?
    end
    memoize :uri
    alias url uri
  end
end
