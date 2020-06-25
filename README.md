# RbHalo

RbHalo is a Ruby client for Halo.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rb-halo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rb-halo

## Usage

```ruby
client = RbHalo::Client.connect('host.acme.org')

client.log("key", "session", "payload")
# or
client.close_session("key", "session")
# then
client.close()
```

You can use the following options:

```
:tls -> Connect to a TLS enabled Halo server
:port -> Port (default is 15443)
:host -> Halo host (name or IP)
:token -> JWT if needed
```
