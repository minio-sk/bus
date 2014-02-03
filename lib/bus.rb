require 'bus/version'

class Bus
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
    @listeners.each do |listener|
      listener.public_send(method_name, *args) if listener.respond_to?(method_name)
    end
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
