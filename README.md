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

class MyPub
  include Besked::Publisher(Int32)
end

class MySub
  include Besked::Subscriber(Int32)

  getter? received : Bool
  getter events : Array(E)

  def initialize
    @received = false
    @events = [] of E
  end

  def receive(event : E)
    @received = true
    @events << event
  end
end

test "local publishers and subscribers" do
  pub = MyPub.new
  sub = MySub.new

  pub.subscribe(sub)

  assert !sub.received?

  pub.publish(1337)

  assert sub.received?
  assert sub.events == [1337]
end
```

## Contributing

1. Fork it ( https://github.com/ragmaanir/besked/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Ragmaanir](https://github.com/ragmaanir) - creator, maintainer
