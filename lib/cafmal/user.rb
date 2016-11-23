# encoding: utf-8

module Cafmal
  class User < Resource

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
