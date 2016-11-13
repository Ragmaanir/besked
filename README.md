# besked [![Build Status](https://travis-ci.org/Ragmaanir/besked.svg?branch=master)](https://travis-ci.org/Ragmaanir/besked)

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
  getter events : Array(Int32)

  def initialize
    @received = false
    @events = [] of Int32
  end

  def receive(event : Int32)
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

