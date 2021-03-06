require 'faraday'
require 'faraday_middleware'

module Tumblr
  module Connection

    def connection(options={})
      options = options.clone

      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => "tumblr_client (ruby) - #{Tumblr::VERSION}"
        },
        :url => "#{api_scheme}://#{api_host}/"
      }

      client = options.delete(:client) || Faraday.default_adapter

      Faraday.new(default_options.merge(options)) do |conn|
        data = { :api_host => api_host }.merge(credentials)
        unless credentials.empty?
          conn.request :oauth, data
        end
        conn.request :multipart
        conn.request :url_encoded
        conn.response :json, :content_type => /\bjson$/
        conn.adapter client
      end
    end

  end
end
