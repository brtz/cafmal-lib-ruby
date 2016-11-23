# encoding: utf-8

module Cafmal
  class Alert
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
      request_show_alert = Cafmal::Request::Get.new(@cafmal_api_url + '/alerts/' + id.to_s, headers)
      if request_show_alert.code < 300
        return request_show_alert.response.body
      end
    end

    def create(cooldown, alert_method, alert_target, is_enabled, minimum_severity, team_id, is_silenced)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      alertdata = {cooldown: cooldown, alert_method: alert_method, alert_target: alert_target, is_enabled: is_enabled, minimum_severity: minimum_severity, team_id: team_id, is_silenced: is_silenced}.to_json
      request_create_alert = Cafmal::Request::Post.new(@cafmal_api_url + '/alerts', alertdata, headers)
      if request_create_alert.code < 300
        return request_create_alert.response.body
      end
    end

  end
end
