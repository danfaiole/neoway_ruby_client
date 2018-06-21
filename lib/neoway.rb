require "neoway/version"
require "neoway/errors"
require "neoway/request"
require 'json'

module Neoway
  class << self
    attr_accessor :user_name, :password
  end

  def base_url
    "https://api.neoway.com.br"
  end
end
