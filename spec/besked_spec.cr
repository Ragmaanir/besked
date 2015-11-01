require "./spec_helper"

module Besked_Tests
  class BeskedTest < Minitest::Test
    def test_global_subscribers_get_notified
      subscriber_called = false

      Besked::Global.subscribe(Besked, "test") do |cls, name, event|
        subscriber_called = true
      end

      assert !subscriber_called

      Besked::Global.publish(Besked, "test", Besked::Event.new)

      assert subscriber_called
    end

  end

  class LocalSubscribersTest < Minitest::Test

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
  end
end
