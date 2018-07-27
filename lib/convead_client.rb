require 'convead_client/client'
require 'convead_client/error'
require 'exts/hash_ext'

module ConveadClient

  # Default way to setup client. 
  def self.setup
    yield self
  end
end
