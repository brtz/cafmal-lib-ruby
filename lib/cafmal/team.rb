# encoding: utf-8

module Cafmal
  class Team
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
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_list_teams = Cafmal::Request::Get.new(@cafmal_api_url + '/teams', headers)

      return request_list_teams.response.body
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_team = Cafmal::Request::Get.new(@cafmal_api_url + '/teams/' + id.to_s, headers)
      if request_show_team.code < 300
        return request_show_team.response.body
      end
    end

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
