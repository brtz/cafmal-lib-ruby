# encoding: utf-8

module Cafmal
  class User
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
      request_show_user = Cafmal::Request::Get.new(@cafmal_api_url + '/users/' + id.to_s, headers)
      if request_show_user.code < 300
        return request_show_user.response.body
      end
    end

    def create(email, password, firstname, lastname, password_digest, role, team_id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      userdata = {email: email, password: password, firstname: firstname, lastname: lastname, password_digest: password_digest, role: role, team_id: team_id}.to_json
      request_create_user = Cafmal::Request::Post.new(@cafmal_api_url + '/users', userdata, headers)
      if request_create_user.code < 300
        return request_create_user.response.body
      end
    end

  end
end
