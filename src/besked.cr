require "./besked/*"

module Besked

  class Event
  end

  alias NameFilter = (String | Regex)

  module Subscriber
    abstract def receive(type : String, name : String, event : Event)
  end

  class SimpleSubscriber
    include Subscriber

    def initialize(&@block : (String, String, Event) ->)
    end

    def receive(type : String, name : String, event : Event)
      @block.call(type, name, event)
    end
  end

  module Publisher
    getter subscribers

    def initialize
      @subscribers = [] of Subscriber
    end

    def subscribe(subscriber : Subscriber)
      subscribers << subscriber
    end

    def publish(type : T.class, name : String, event : Event)
      @subscribers.each{ |s| s.receive(type.name, name, event) }
    end
  end

  class GlobalPublisher

    class EventFilter
      getter type, filter

      def initialize(@type : String, @filter = nil : NameFilter?)
      end

      def passes?(t : String, name : String)
        type == t && filter === name
      end

      def ==(other : self)
        type == other.type && filter == other.filter
      end
    end

    # TODO allow multiple subscribers
    # TODO allow unsubscribing
    @subscribers = {} of EventFilter => Subscriber

    def subscribe(type : T.class, filter : NameFilter, &block : ((String, String, Event) ->))
      ef = EventFilter.new(type.name, filter)
      @subscribers[ef] = SimpleSubscriber.new(&block)
    end

    def publish(type : T.class, name : String, event : Event)
      @subscribers.each do |filter, sub|
        if filter.passes?(type.name, name)
          sub.receive(type.name, name, event)
        end
      end
    end
  end

  Global = GlobalPublisher.new

end
