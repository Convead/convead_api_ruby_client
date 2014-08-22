# ConveadClient

Ruby client for Convead API (http://convead.com)

## Installation

Add this line to your application's Gemfile:

    gem 'convead_client', github: 'Convead/convead_api_ruby_client'

And then execute:

    $ bundle

## Usage

Create instance of client:

    client = Convead::Client.new('APP_KEY', 'DOMAIN', options = {})
    
Options:

  - `adapter` - [Faraday](https://github.com/lostisland/faraday) adapter. Default is `:net_http`
 
### Events

Events can be sent using `event` method which takes 3 arguments: event type, event properties and optionally visitor properties, e.g.:

    client.event('link', {visitor_uid: '12345', path: '/foo/bar'})
    
    client.event('link', {visitor_uid: '12345', path: '/foo/bar'}, {first_name: 'Foo', last_name: 'Bar'})
    
## TODO

Write description of event types and properties
