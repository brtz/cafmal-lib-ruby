# encoding: utf-8

module Cafmal
  class Worker < Resource

    def create(uuid, supported_sourcetype, heartbeat_received_at)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      workerdata = {uuid: uuid, supported_sourcetype: supported_sourcetype, heartbeat_received_at: heartbeat_received_at}.to_json
      request_create_worker = Cafmal::Request::Post.new(@cafmal_api_url + '/workers', workerdata, headers)
      if request_create_worker.code < 300
        return request_create_worker.response.body
      end
    end

  end
end
