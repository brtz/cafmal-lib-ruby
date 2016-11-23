# encoding: utf-8

module Cafmal
  class Alert < Resource

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
