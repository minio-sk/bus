require 'bus/version'

class Bus
  class NoListenerRespondedError < RuntimeError; end

  def initialize(listeners = [])
    @listeners = listeners
  end

  def attach(listener)
    self.class.new(@listeners + [listener])
  end

  def on(event_or_hash, &block)
    listeners = block_given? ? [CallableListener.new(event_or_hash, block)] : build_listeners_from_hash(event_or_hash)
    self.class.new(@listeners + listeners)
  end

  def method_missing(method_name, *args)
    responded = false
    @listeners.each do |listener|
      if listener.respond_to?(method_name)
        responded = true
        listener.public_send(method_name, *args)
      end
    end
    raise NoListenerRespondedError.new("No listener responded to message '#{method_name}'") unless responded
  end

  private
  def build_listeners_from_hash(event_or_hash)
    event_or_hash.map do |event, callable|
      CallableListener.new(event, callable)
    end
  end

  class CallableListener < Struct.new(:event, :callable)
    def method_missing(_, *args)
      callable.call(*args)
    end

    def respond_to?(method_name)
      event == method_name
    end
  end
end
