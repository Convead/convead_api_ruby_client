# ConveadClient

Ruby client for Convead API (http://convead.com)

## Installation

Add this line to your application's Gemfile:

    gem 'convead_client', github: 'Convead/convead_api_ruby_client'

And then execute:

    $ bundle

## Usage

Create instance of the client:

    client = ConveadClient::Client.new('APP_KEY', 'DOMAIN', options = {})
    
Options:

  - `ssl` - use https instead of http
 
### Events

Events can be sent using `event` method which takes 5 arguments: 
* [required] event type
* [required] event root parameters
* [optional] event specific properties
* [optional] visitor info
* [optional] event arguments

See examples [below](#usage-example).
    
#### Event types

| Type             | Description                |
|------------------|----------------------------|
| link             | Page visited.              |
| mailto           | Email sent.                |
| file             | File downloaded.           |
| view_product     | Product viewed.            |
| add_to_cart      | Product added to cart.     |
| remove_from_cart | Product removed from cart. |
| update_cart      | Cart updated. Will override all previous add_to_cart/remove_from_cart events in this session. |
| purchase         | Product(s) purchased.      |
| custom           | Custom event (must be configured in Convead account first). |

#### Root event parameters

| Name        | Description                                | Default value |
|-------------|--------------------------------------|-----|
| domain      | [required] Convead account's domain. | Domain from initializer. |
| host        | [required] Host of the site incl. port. | Domain from initializer. |
| url         | [required] URL of the page. | Domain root URL. | 
| path        | [required] Relative path of the page. | Domain root path. |
| visitor_uid | Unique identifier of the visitor. Only [0-9a-z-] characters are allowed. visitor_uid or guest_uid is required. | |
| guest_uid   | Unique identifier of the guest visitor. Can be obtained from `convead_guest_uid` cookie. **visitor_uid or guest_uid is required**. | |
| title       | Title of the page.                   | |
| referrer    | Referrer URL.                        | |

#### Event specific properties

##### mailto
| Name  | Description               |
|-------|---------------------------|
| email | [required] Clicked email. |

##### file
| Name       | Description                                                        |
|------------|--------------------------------------------------------------------|
| file_url   | [required]                                                         |
| file_title | File title. Shown in visitor's timeline at Convead when specified. |


##### view_product
| Name         | Description                                                                                             |
|--------------|---------------------------------------------------------------------------------------------------------|
| product_id   | [required] Your internal product id. The same as you specify in Yandex.Market/Google Merchant XML feed. |
| product_name | Product title. If not specified, Convead will try to get it from your website's XML feed.               |
| product_url  | Product permanent URL. If not specified, Convead will try to get it from your website's XML feed.       |

##### add_to_cart
| Name          | Description                                                                                             |
|---------------|---------------------------------------------------------------------------------------------------------|
| product_id    | [required] Your internal product id. The same as you specify in Yandex.Market/Google Merchant XML feed. |
| qnt           | [required] Quantity of product items added.                                                             |
| product_price | [required] Product price, only numeric. If not specified, Convead will try to get it from your website's XML feed. |
| product_name  | Product title. If not specified, Convead will try to get it from your website's XML feed.               |
| product_url   | Product permanent URL. If not specified, Convead will try to get it from your website's XML feed.       |

##### removed_from_cart
| Name          | Description                                                                                             |
|---------------|---------------------------------------------------------------------------------------------------------|
| product_id    | [required] Your internal product id. The same as you specify in Yandex.Market/Google Merchant XML feed. |
| qnt           | [required] Quantity of product items removed.                                                           |

##### update_cart
| Name          | Description                                                                                             |
|---------------|---------------------------------------------------------------------------------------------------------|
| items         | [required] Array of line items in cart. Each item is a JSON object: `{product_id: 1234, qnt: 1, price: 100.0}`. See more examples below. |

##### purchase
| Name     | Notes       |
|----------|-------------|
| revenue  | [required] Order total.            |
| order_id | [required] Unique identifier of the order (id or number). |
| items    | Array of order line items, e.g. `items: [{product_id: 1234, qnt: 1, price: 100.0}, {...}]` |

##### custom
| Name     | Notes       |
|----------|-------------|
| key      | [required] Custom event key in Convead. |

#### Visitor info

Current visitor's parameters (if any known):

```javascript
{
  first_name: 'Foo',
  last_name: 'Bar',
  email: 'email',
  phone: '1-111-11-11-11',
  date_of_birth: '1984-06-16',
  gender: 'male',
  language: 'ru',
  custom_field_1: 'custom value 1',
  custom_field_2: 'custom value 2',
  ...
}
```

#### Usage example

```ruby
# Initialize client.
client = ConveadClient::Client.new('<your_app_key>', '<your_domain>', options = {})

# Visitor Foo Bar has visited a /test page with title "Test page".
client.event('link', {visitor_uid: '1', path: '/test', title: 'Test page'}, {}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has clicked a mailto:-link with email 'test@example.net' on page /test with title "Test page".
client.event('mailto', {visitor_uid: '1', path: '/test', title: 'Test page'}, {email: 'test@example.net'}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has downloaded a file from http://example.net/test/file.pdf with title "File 1" from page /test with title "Test page".
client.event('file', {visitor_uid: '1', path: '/test', title: 'Test page'}, {file_url: 'http://example.net/test/file.pdf', file_title: 'File 1'}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has viewed a product "Product 1" with ID 1 on page /products/product-1.
client.event('view_product', {visitor_uid: '1', path: '/products/product-1', title: 'Product 1 page'}, {product_id: 1, product_name: 'Product 1', product_url: 'http://example.net/products/product-1'}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has added one item of "Product 1" with price 100.0 to cart.
client.event('add_to_cart', {visitor_uid: '1', path: '/products/product-1', title: 'Product 1 page'}, {product_id: 1, qnt: 1, product_name: 'Product 1', product_url: 'http://example.net/products/product-1', price: 100.0}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has removed one item of product with ID 1 from cart.
client.event('remove_from_cart', {visitor_uid: '1', path: '/products/product-1', title: 'Product 1 page'}, {product_id: 1, qnt: 1}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has emptied his cart.
client.event('update_cart', {visitor_uid: '1', path: '/products/product-1', title: 'Product 1 page'}, {items: []}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has updated his cart contents with two products.
client.event('update_cart', {visitor_uid: '1', path: '/products/product-1', title: 'Product 1 page'}, {items: [{product_id: 1234, qnt: 1, price: 100.0}, {product_id: 4321, qnt: 2, price: 99.0}]}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor Foo Bar has purchased two products with total revenue 298.0 and order ID 123.
client.event('purchase', {visitor_uid: '1', path: '/checkout/thank_you', title: 'Thank you!'}, {order_id: '123', revenue: '298.0', items: [{product_id: 1234, qnt: 1, price: 100.0}, {product_id: 4321, qnt: 2, price: 99.0}]}, {first_name: 'Foo', last_name: 'Bar'})

# Visitor performed a custom event with key 'my_custom_event'.
client.event('custom', {visitor_uid: '29'}, {key: 'my_custom_event'})
```

## API

#### Usage

Create instance of the api client:

    api = ConveadClient::Api.new('APP_KEY_or_ACCOUNT_ID')

#### Methods

##### send

| Params           | Description                                                       |
|------------------|-------------------------------------------------------------------|
| path             | [required] Path postfix by api (more https://convead.io/api-doc). |
| method           | The http method. Default value 'GET' .                            |
| params           | Params for 'POST' method.                                         |

##### order_delete

| Params           | Description                            |
|------------------|----------------------------------------|
| order_id         | [required] ID order to be removed.     |

##### order_set_state

| Params           | Description                               |
|------------------|-------------------------------------------|
| order_id         | [required] ID order to be updates state.  |
| state            | Order status to be assigned to the order. |

#### Usage example

```ruby
# Initialize api client.
api = ConveadClient::Api.new('<your_app_key_or_account_id>')

# Get visitors by segment id=333. Learn more at https://convead.io/api-doc
api.send('accounts/segments/333/visitors')

# Update visitor id=99 email by 'mail@example.net'. Learn more at https://convead.io/api-doc
api.send('accounts/visitors/99', 'PUT', {email: 'mail@example.net'})

# Order id=123 was deleted
api.order_delete(123)

# Order id=123 was paid state
api.order_set_state(123, 'paid')
```