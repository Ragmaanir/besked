# besked

Event System for notifications similar to ActiveSupport Instrumentation.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  besked:
    github: ragmaanir/besked
```


## Usage


```crystal
require "besked"
```

### Global event system
```crystal
subscriber_called = false

Besked::Global.subscribe(Besked, "test") do |cls, name, event|
  subscriber_called = true
end

assert !subscriber_called

Besked::Global.publish(Besked, "test", Besked::Event.new)

assert subscriber_called
```

### Local pub/sub
```crystal
class MyPub
  include Besked::Publisher
end

class MySub
  include Besked::Subscriber

  getter? received

  def initialize
    @received = false
  end

  def receive(type : String, name : String, event : Besked::Event)
    @received = true
  end
end

def test_local_publishers_and_subscribers
  pub = MyPub.new
  sub = MySub.new

  pub.subscribe(sub)

  assert !sub.received?

  pub.publish(MyPub, "test", Besked::Event.new)

  assert sub.received?
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/ragmaanir/besked/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Ragmaanir](https://github.com/ragmaanir) - creator, maintainer
