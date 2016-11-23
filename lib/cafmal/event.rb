# encoding: utf-8

module Cafmal
  class Event
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

    def list(age = nil, duration = 3600)
      query = age.nil? ? "" : "?query[age]=#{age}&query[duration]=#{duration}"

      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_list_events = Cafmal::Request::Get.new(@cafmal_api_url + '/events' + query, headers)

      return request_list_events.response.body
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_event = Cafmal::Request::Get.new(@cafmal_api_url + '/events/' + id.to_s, headers)
      if request_show_event.code < 300
        return request_show_event.response.body
      end
    end

    def create(name, message, kind, severity, team_id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      eventdata = {name: name, message: message, kind: kind, severity: severity, team_id: team_id}.to_json
      request_create_event = Cafmal::Request::Post.new(@cafmal_api_url + '/events', eventdata, headers)
      if request_create_event.code < 300
        return request_create_event.response.body
      end
    end

  end
end
