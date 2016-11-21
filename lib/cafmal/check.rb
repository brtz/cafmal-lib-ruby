# encoding: utf-8

module Cafmal
  class Check
    @token = nil
    @decoded_token = nil
    @cafmal_api_url = nil

    attr_reader :token
    attr_reader :decoded_token
    attr_reader :cafmal_api_url

    def initialize(auth)
      @cafmal_api_url = auth.cafmal_api_url
      @token = auth.token
      @decoded_token = {}
      @decoded_token['header'] = JSON.parse(Base64.decode64(@token.split('.')[0]))
      @decoded_token['payload'] = JSON.parse(Base64.decode64(@token.split('.')[1]))
    end

    def list()
      #
    end

    def show(id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      request_show_check = Cafmal::Request::Get.new(@cafmal_api_url + '/checks/' + id.to_s, headers)
      if request_show_check.code < 300
        JSON.parse(request_show_check.response.body)
      end
    end

    def create(category, name, condition_query, condition_operand, condition_aggregator, severity, interval, is_locked, last_ran_at, team_id, datasource_id)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      checkdata = {
        category: category,
        name: name,
        condition_query: condition_query,
        condition_operand: condition_operand,
        condition_aggregator: condition_aggregator,
        severity: severity,
        interval: interval,
        is_locked: is_locked,
        last_ran_at: last_ran_at,
        team_id: team_id,
        datasource_id: datasource_id
      }.to_json
      request_create_check = Cafmal::Request::Post.new(@cafmal_api_url + '/checks', checkdata, headers)
      if request_create_check.code < 300
        JSON.parse(request_create_check.response.body)['id']
      end
    end

  end
end
