RakutenWebService.configure do |c|
  c.application_id = ENV["RAKUTEN_APPLICATION_ID"]
end

require 'net/http'
require "uri"
require "json"