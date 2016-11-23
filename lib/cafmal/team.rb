# encoding: utf-8

module Cafmal
  class Team < Resource

    def create(name)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      teamdata = {name: name}.to_json
      request_create_team = Cafmal::Request::Post.new(@cafmal_api_url + '/teams', teamdata, headers)
      if request_create_team.code < 300
        return request_create_team.response.body
      end
    end

  end
end
