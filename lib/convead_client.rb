require 'convead_client/client'
require 'convead_client/api'
require 'convead_client/error'
require 'exts/hash_ext'

module ConveadClient
  
  mattr_accessor :api_url
  @@api_url = 'https://tracker.convead.io'

  def self.api_url
    @@api_url
  end

  # Default way to setup client. 
  def self.setup
    yield self
  end
end
