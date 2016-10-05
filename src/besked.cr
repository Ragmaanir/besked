require "kontrakt"
require "./besked/*"

module Besked
  module Subscriber(E)
    abstract def receive(event : E)
  end

  module Publisher(E)
    getter subscribers : Array(Subscriber(E))

    def initialize
      @subscribers = [] of Subscriber(E)
    end

    def subscribed?(subscriber : Subscriber(E))
      subscribers.includes?(subscriber)
    end

    def subscribe(subscriber : Subscriber(E))
      Kontrakt.precondition(!subscribers.includes?(subscriber))
      subscribers << subscriber
    end

    def unsubscribe(subscriber : Subscriber(E))
      Kontrakt.precondition(subscribers.includes?(subscriber))
      subscribers.delete(subscriber)
    end

    def publish(event : E)
      subscribers.each { |s| s.receive(event) }
    end
  end
end
