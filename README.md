# ConveadClient

Ruby client for Convead API (http://convead.com)

## Installation

Add this line to your application's Gemfile:

    gem 'convead_client', github: 'Convead/convead_api_ruby_client'

And then execute:

    $ bundle

## Usage

Create instance of the client:

    client = Convead::Client.new('APP_KEY', 'DOMAIN', options = {})
    
Options:

  - `adapter` - [Faraday](https://github.com/lostisland/faraday) adapter. Default is `:net_http`
 
### Events

Events can be sent using `event` method which takes 3 arguments: event type, event properties and optionally visitor properties, e.g.:

    client.event('link', {visitor_uid: '12345', path: '/foo/bar'})
    
    client.event('link', {visitor_uid: '12345', path: '/foo/bar'}, {first_name: 'Foo', last_name: 'Bar'})
    
#### Event types

| Type     | Description          |
|----------|-----------------------|
| link     | Visitor visited page. |
| mailto   | Sent mail.            |
| file     | Downloaded file.      |
| purchase | Bought product.       |
| view     | Viewed widget.        |
| submit   | Submitted widget.     |
| close    | Closed widget.        |

#### Event properties

| Name        | Notes                                |
|-------------|--------------------------------------|
| path        | Relative path of the page. Required. |
| visitor_uid | Unique identifier of the visitor. Only [0-9a-z-] characters are allowed. visitor_uid or guest_uid is required. |
| guest_uid   | Unique identifier of the guest visitor. Can be obtained from `convead_guest_uid` cookies. visitor_uid or guest_uid is required. |
| title       | Title of the page.                   |
| referrer    | Referrer url.                        |
| key_page_id | Id of the key page to specify it manually, i.e. without using regular expression in key page form. |

#### Event specific properties

##### mailto
| Name  | Notes     |
|-------|-----------|
| email | Required. |

##### file
| Name     | Notes     |
|----------|-----------|
| file_url | Required. |

##### purchase
| Name     | Notes       |
|----------|-------------|
| revenue  |             |
| order_id | Unique identifier of the order |
| items    | Array of products in the order, e.g. `items: [{id: 1234, qnt: 1, price: 100.0}, {...}]` |

##### view
| Name      | Notes             |
|-----------|-------------------|
| widget_id | Id of the widget. |

##### submit
| Name      | Notes             |
|-----------|-------------------|
| widget_id | Id of the widget. |

##### close
| Name      | Notes             |
|-----------|-------------------|
| widget_id | Id of the widget. |
