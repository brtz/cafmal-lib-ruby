# encoding: utf-8

require 'httparty'
require 'cafmal/version'

module Cafmal
  autoload 'Alert', 'cafmal/alert'
  autoload 'Alerter', 'cafmal/alerter'
  autoload 'Auth', 'cafmal/auth'
  autoload 'Check', 'cafmal/check'
  autoload 'Datasource', 'cafmal/datasource'
  autoload 'Event', 'cafmal/event'
  autoload 'Team', 'cafmal/team'
  autoload 'User', 'cafmal/user'
  autoload 'Worker', 'cafmal/worker'
end

require 'cafmal/resource'
require 'cafmal/request'
