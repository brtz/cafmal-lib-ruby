# encoding: utf-8

module Cafmal
  class Check < Resource

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
        return request_create_check.response.body
      end
    end

  end
end
