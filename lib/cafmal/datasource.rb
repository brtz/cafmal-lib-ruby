# encoding: utf-8

module Cafmal
  class Datasource < Resource

    def create(sourcetype, address, port, protocol, username, password)
      headers = {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}"}
      datasourcedata = {sourcetype: sourcetype, address: address, port: port, protocol: protocol, username: username, password: password}.to_json
      request_create_datasource = Cafmal::Request::Post.new(@cafmal_api_url + '/datasources', datasourcedata, headers)
      if request_create_datasource.code < 300
        return request_create_datasource.response.body
      end
    end

  end
end
