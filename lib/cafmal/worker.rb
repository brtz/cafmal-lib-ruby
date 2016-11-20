# encoding: utf-8

module Cafmal
  class Event
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url

    def initialize(api_url, token)
      @cafmal_api_url = api_url
      @token = token
      @decoded_token = {}
      @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
      @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))
    end

    def list(name = nil, between_start = nil, between_end = nil, message = nil, kind = nil, severity = nil, team_id = nil)
      #
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_event = Cafmal::Request::Get.new(@cafmal_api_url + '/events/' + id.to_s, headers)
      if request_show_event.code < 300
        JSON.parse(request_show_event.response.body)
      end
    end

    def create(name, message, kind, severity, team_id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      eventdata = {name: name, message: message, kind: kind, severity: severity, team_id: team_id}.to_json
      request_create_event = Cafmal::Request::Post.new(@cafmal_api_url + '/events', eventdata, headers)
      if request_create_event.code < 300
        JSON.parse(request_create_event.response.body)['id']
      end
    end

  end
end
