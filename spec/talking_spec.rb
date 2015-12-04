require 'spec_helper'
require 'stringio'

describe Talking do
  it 'has a version number' do
    expect(Talking::VERSION).not_to be nil
  end

  describe Talking::Mouth do
    let(:natural_stream) do
      StringIO.new
    end

    let(:natural_voice) do
      Talking::StreamVoice.new(natural_stream)
    end

    let(:debug_stream) do
      StringIO.new
    end

    let(:debug_voice) do
      Talking::StreamVoice.new(debug_stream)
    end

    let(:mouth) do
      Talking::Mouth.new(natural_stream, debug_stream)
    end

    let(:message) do
      "Luke, I'm your father!"
    end

    describe '#say' do
      it 'produces standard messages' do
        mouth.say(message)
        expect(natural_stream.string).to eq("#{message}\n")
      end
    end

    describe '#debug' do
      it 'produces debug messages' do
        mouth.debug(message)
        expect(debug_stream.string).to eq("DEBUG: #{message}\n")
      end
    end
  end

  describe Talking::Talkative do
    let(:dummy_klass) do
      Class.new do
        include Talking::Talkative
      end
    end

    let(:dummy) do
      dummy_klass.new
    end

    let(:message) do
      "You know nothing Jon Snow!"
    end

    it 'adds #mouth' do
      expect(dummy.mouth).to be_kind_of(Talking::Mouth)
    end

    it 'delegates #say to mouth' do
      expect(dummy.mouth).to receive(:say).with(message)
      dummy.say(message)
    end

    it 'delegates #debug to mouth' do
      expect(dummy.mouth).to receive(:debug).with(message)
      dummy.debug(message)
    end
  end
end
