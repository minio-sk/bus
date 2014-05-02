require 'spec_helper'
require 'bus'

describe Bus do
  let (:listener) { double }

  it 'calls attached listener' do
    bus = subject.attach(listener)

    expect(listener).to receive(:event_fired)

    bus.event_fired
  end

  it 'calls attached listener with params' do
    bus = subject.attach(listener)

    expect(listener).to receive(:event_fired).with(1, 2, 3)

    bus.event_fired(1, 2, 3)
  end

  it 'does not call listener if it does not respond to event' do
    non_responding_listener = double(respond_to?: false)
    responding_listener = double.as_null_object
    bus = subject.attach(non_responding_listener).attach(responding_listener)

    expect(non_responding_listener).not_to receive(:event_fired)

    bus.event_fired
  end

  it 'calls multiple listeners' do
    listener1 = double
    listener2 = double

    bus = subject.attach(listener1).attach(listener2)

    expect(listener1).to receive(:event_fired)
    expect(listener2).to receive(:event_fired)

    bus.event_fired
  end

  it 'calls lightweight listener defined from hash' do
    bus = subject.on(event_fired: listener) # event_fired: ->(args) { do stuff }

    expect(listener).to receive(:call).with(:args)

    bus.event_fired(:args)
  end

  it 'calls lightweight listener defined from block' do
    bus = subject.on(:event_fired) {|args| listener.call(args)} # event_fired { do stuff }

    expect(listener).to receive(:call).with(:args)

    bus.event_fired(:args)
  end

  it 'aliases on and when methods' do
    bus = subject.when(:event_fired) {|args| listener.call(args)} # event_fired { do stuff }

    expect(listener).to receive(:call).with(:args)

    bus.event_fired(:args)
  end

  it 'throws an exception when no listener responds' do
    expect { subject.event_fired }.to raise_error(Bus::NoListenerRespondedError, 'No listener responded to message \'event_fired\'')
  end
end