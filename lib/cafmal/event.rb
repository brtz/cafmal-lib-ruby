# encoding: utf-8

module Cafmal
  class Event < Resource

    def list(age = nil, duration = 3600)
      @query = age.nil? ? "" : "?query[age]=#{age}&query[duration]=#{duration}"

      super
    end

  end
end
