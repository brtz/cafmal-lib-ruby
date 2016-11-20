# encoding: utf-8

require 'httparty'
require 'cafmal/version'

module Cafmal
  autoload 'Auth', 'cafmal/auth'
  autoload 'Event', 'cafmal/event'
  autoload 'Team', 'cafmal/team'
  autoload 'User', 'cafmal/user'
end

require 'cafmal/request'
