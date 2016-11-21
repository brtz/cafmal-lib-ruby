# encoding: utf-8

module Cafmal
  class Datasource
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url

    def initialize(auth)
      @cafmal_api_url = auth.cafmal_api_url
      @token = auth.token
      @decoded_token = {}
      @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
      @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))
    end

    def list(name = nil, between_start = nil, between_end = nil, message = nil, kind = nil, severity = nil, team_id = nil)
      #
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_datasource = Cafmal::Request::Get.new(@cafmal_api_url + '/datasources/' + id.to_s, headers)
      if request_show_datasource.code < 300
        JSON.parse(request_show_datasource.response.body)
      end
    end

    def create(sourcetype, address, port, protocol, username, password)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      datasourcedata = {sourcetype: sourcetype, address: address, port: port, protocol: protocol, username: username, password: password}.to_json
      request_create_datasource = Cafmal::Request::Post.new(@cafmal_api_url + '/datasources', datasourcedata, headers)
      if request_create_datasource.code < 300
        JSON.parse(request_create_datasource.response.body)['id']
      end
    end

  end
end