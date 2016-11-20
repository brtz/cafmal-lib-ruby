# encoding: utf-8

require 'httparty'
require 'cafmal/version'

module Cafmal
  autoload 'Auth', 'cafmal/auth'
  autoload 'Event', 'cafmal/event'
end

require 'cafmal/request'
