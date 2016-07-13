require 'httparty'
require 'recursive_open_struct'

class Vm::Base
  include HTTParty
  base_uri 'http://0.0.0.0:8000/'
end