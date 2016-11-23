# encoding: utf-8

module Cafmal
  class Event < Resource

    def list(age = nil, duration = 3600)
      @query = age.nil? ? "" : "?query[age]=#{age}&query[duration]=#{duration}"

      super
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
