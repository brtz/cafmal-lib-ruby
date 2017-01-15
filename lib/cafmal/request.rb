# encoding: utf-8

module Cafmal
  module Request
    @response = nil

    class Post
      attr_reader :response

      def initialize(url, body, headers)
        @response = HTTParty.post(url, body: body, headers: headers)
      end
    end

    class Get
      attr_reader :response

      def initialize(url, headers)
        @response = HTTParty.get(url, headers: headers)
      end
    end

    class Put
      attr_reader :response

      def initialize(url, body, headers)
        @response = HTTParty.put(url, body: body, headers: headers)
      end
    end

    class Delete
      attr_reader :response

      def initialize(url, body, headers)
        @response = HTTParty.delete(url, body: body, headers: headers)
      end
    end

  end
end
