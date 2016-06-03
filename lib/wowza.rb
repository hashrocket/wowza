require 'wowza/version'
require 'base64'
require 'json'
require 'indifference' unless defined?(ActiveSupport)
require 'assignment'
require 'net/http/digest_auth'

require 'wowza/will_change'

require 'wowza/rest/publishers'
require 'wowza/rest/publisher'
require 'wowza/rest/authentication'
require 'wowza/rest/connection'
require 'wowza/rest/server'
require 'wowza/rest/status_parser'
require 'wowza/rest/client'
require 'wowza/rest/applications'
require 'wowza/rest/application'
require 'wowza/rest/instances'
require 'wowza/rest/instance'
require 'wowza/rest/stream'
require 'wowza/rest/stream_group'

module Wowza
end
