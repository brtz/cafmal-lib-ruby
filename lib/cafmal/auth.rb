# encoding: utf-8

module Cafmal
  class Auth
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url

    def initialize(api_url)
      @cafmal_api_url = api_url
    end

    def expired?(force = false)
      is_expired = false
      if @token.nil?
        is_expired = true
      else
        is_expired = (Time.at(@decoded_token['payload']['exp']).utc.to_datetime < Time.now().utc.to_datetime)
        # force is checking against auth from the api itself instead of relying on JWT exp
        if force
          request_user = Cafmal::User.new(self).show(@decoded_token['payload']['sub'])
          is_expired = request_user.nil?
        end
      end
      return is_expired
    end

    def login(email = 'admin@example.com', password = 'cafmal')
      credentials = {auth: {email: email, password: password}}.to_json
      request_auth = Cafmal::Request::Post.new(@cafmal_api_url + '/user_token', credentials, {"Content-Type" => "application/json"})
      if request_auth.code < 300
        @token = JSON.parse(request_auth.response.body)["jwt"]
        @decoded_token = {}
        @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
        @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))

        team_id = Cafmal::User.new(self).show(@decoded_token['payload']['sub'])["team_id"]

        event = Cafmal::Event.new(self)
        event.create('user_login', "#{email} has logged in.", 'login', 'info', team_id)

        true
      end
    end

    def logout
      unless @token.nil?
        headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}

        user = Cafmal::User.new(self).show(@decoded_token['payload']['sub'])
        team_id = user["team_id"]
        email = user["email"]

        # kind has to be login, as it's a label of events
        event_id = Cafmal::Event.new(self).create('user_logout', "#{email} has logged out.", 'login', 'info', team_id)

        if event_id.nil?
          false
        else
          @token = nil
          @decoded_token = nil
          true
        end
      end

    end
  end
end
