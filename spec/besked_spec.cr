require "./spec_helper"

describe Besked do
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

  test "subscribe and unsubscribe" do
    pub = MyPub.new
    sub = MySub.new

    assert !pub.subscribed?(sub)

    pub.subscribe(sub)

    assert pub.subscribed?(sub)

    pub.unsubscribe(sub)

    assert !pub.subscribed?(sub)
  end

  test "double subscribe and unsubscribe" do
    pub = MyPub.new
    sub = MySub.new

    pub.subscribe(sub)
    assert_raises(Kontrakt::PreConditionViolation) do
      pub.subscribe(sub)
    end

    pub.unsubscribe(sub)

    assert_raises(Kontrakt::PreConditionViolation) do
      pub.unsubscribe(sub)
    end

    assert !pub.subscribed?(sub)
  end
end
