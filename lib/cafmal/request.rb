# encoding: utf-8

module Cafmal
  module Request
    @response = nil
    @code = nil

    class Post
      attr_reader :response
      attr_reader :code

      def initialize(url, body, headers)
        @response = HTTParty.post(url, body: body, headers: headers)
        @code = @response.code
      end
    end

    class Get
      attr_reader :response
      attr_reader :code

      def initialize(url, headers)
        @response = HTTParty.get(url, headers: headers)
        @code = @response.code
      end
    end

    class Put
      attr_reader :response
      attr_reader :code

      def initialize(url, body, headers)
        @response = HTTParty.put(url, body: body, headers: headers)
        @code = @response.code
      end
    end

    class Delete
      attr_reader :response
      attr_reader :code

      def initialize(url, body, headers)
        @response = HTTParty.delete(url, body: body, headers: headers)
        @code = @response.code
      end
    end

  end
end
