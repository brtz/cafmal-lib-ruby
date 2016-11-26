# encoding: utf-8

module Cafmal
  class Resource
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil
    @query = nil
    @headers = nil
    @resourcename = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url
    attr_reader :query
    attr_writer :query

    def initialize(cafmal_api_url, token)
      @cafmal_api_url = cafmal_api_url
      @token = token
      @decoded_token = {}
      @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
      @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))
      @query = ""
      @headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      @resourcename = (demodulize(self.class.name) + "s").downcase
    end

    def create(params)
      request_create_resource = Cafmal::Request::Post.new(@cafmal_api_url + "/#{@resourcename}", params.to_json, @headers)

      return request_create_resource.response.body
    end

    def new
      request_new_resource = Cafmal::Request::Get.new(@cafmal_api_url + "/#{@resourcename}/new", @headers)

      return request_new_resource.response.body
    end

    def list(*options)
      request_list_resource = Cafmal::Request::Get.new(@cafmal_api_url + "/#{@resourcename}" + @query, @headers)

      return request_list_resource.response.body
    end

    def show(id)
      request_show_resource = Cafmal::Request::Get.new(@cafmal_api_url + "/#{@resourcename}/" + id.to_s, @headers)

      return request_show_resource.response.body
    end

    def update(params)
      request_update_resource = Cafmal::Request::Put.new(@cafmal_api_url + "/#{@resourcename}/#{params['id']}", params.to_json, @headers)

      return request_update_resource.response.body
    end

    def destroy(params)
      request_destroy_resource = Cafmal::Request::Delete.new(@cafmal_api_url + "/#{@resourcename}/#{params['id']}", params.to_json, @headers)

      return request_destroy_resource.response.body
    end

    # helpers below

    def demodulize(path)
      path = path.to_s
      if i = path.rindex('::')
        path[(i+2)..-1]
      else
        path
      end
    end

  end
end
