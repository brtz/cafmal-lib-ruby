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
          request_user = JSON.parse(Cafmal::User.new(@cafmal_api_url, @token).show(@decoded_token['payload']['sub']))
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

        if (@decoded_token['payload']['role'] != 'worker' && @decoded_token['payload']['role'] != 'alerter')
          team_id = JSON.parse(Cafmal::User.new(@cafmal_api_url, @token).show(@decoded_token['payload']['sub']))["team_id"]
          event = Cafmal::Event.new(@cafmal_api_url, @token)
          event.create({name: 'user.login', message: "#{email} has logged in.", kind: 'login', severity: 'info', team_id: team_id})

          #@TODO silence all alerts for your team_id, set silenced_at now + 1h
        end

        true
      end
    end

    # we supply the token here, so web does not have to cache the auth obj
    def logout(token)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}

      decoded_token = {}
      decoded_token['header'] = JSON.parse(Base64.decode64(token.split('.')[0]))
      decoded_token['payload'] = JSON.parse(Base64.decode64(token.split('.')[1]))

      user = JSON.parse(Cafmal::User.new(@cafmal_api_url, token).show(decoded_token['payload']['sub']))
      team_id = user["team_id"]
      email = user["email"]

      #@TODO if you are the last logged in user, unsilence your team alerts

      # kind has to be login, as it's a label of events
      event_id = JSON.parse(Cafmal::Event.new(@cafmal_api_url, token).create({name: 'user.logout', message: "#{email} has logged out.", kind: 'login', severity: 'info', team_id: team_id}))

      if event_id.nil?
        false
      else
        @token = nil
        @decoded_token = nil
        true
      end
    end

    # refresh token
    def refresh(token)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"}
      credentials = {token: token}.to_json
      refresh_request = Cafmal::Request::Post.new(@cafmal_api_url + '/user_token_refresh', credentials, headers)
      if refresh_request.code < 300
        @token = JSON.parse(refresh_request.response.body)['jwt']
        @decoded_token = {}
        @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
        @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))

        if (@decoded_token['payload']['role'] != 'worker' && @decoded_token['payload']['role'] != 'alerter')
          team_id = JSON.parse(Cafmal::User.new(@cafmal_api_url, @token).show(@decoded_token['payload']['sub']))["team_id"]
          event = Cafmal::Event.new(@cafmal_api_url, @token)
          event.create({name: 'user.refresh_login', message: "#{@decoded_token['payload']['email']} has refreshed his login.", kind: 'login', severity: 'info', team_id: team_id})

          #@TODO silence all alerts for your team_id, set silenced_at now + 1h
        end
        return true
      else
        return false
      end
    end
  end
end
