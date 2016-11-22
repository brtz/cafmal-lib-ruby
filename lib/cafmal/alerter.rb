# encoding: utf-8

module Cafmal
  class Alerter
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url

    def initialize(cafmal_api_url, token)
      @cafmal_api_url = cafmal_api_url
      @token = token
      @decoded_token = {}
      @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
      @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))
    end

    def list()
      #
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_alerter = Cafmal::Request::Get.new(@cafmal_api_url + '/alerters/' + id.to_s, headers)
      if request_show_alerter.code < 300
        return request_show_alerter.response.body
      end
    end

    def create(uuid, supported_targets, heartbeat_received_at)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      alerterdata = {uuid: uuid, supported_targets: supported_targets, heartbeat_received_at: heartbeat_received_at}.to_json
      request_create_alerter = Cafmal::Request::Post.new(@cafmal_api_url + '/alerters', alerterdata, headers)
      if request_create_alerter.code < 300
        return request_create_alerter.response.body
      end
    end

  end
end
