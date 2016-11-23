# encoding: utf-8

module Cafmal
  class Alerter < Resource

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
