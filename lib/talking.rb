require "talking/version"
require "forwardable"
require "singleton"

# Public: A talking module. It allows our program to verbosely tell us what he does while
# performing stuff around.
module Talking
  # Public: Silence. Mutes our poor program.
  class NullVoice
    include Singleton

    def puts(msg, *args)
    end
  end

  # Public: Simple to-stream output voice. It prints stuff up to initialized IO.
  StreamVoice = Struct.new(:stream) do
    def puts(msg, *args)
      stream.puts(format(msg, *args))
    end
  end

  # Public: Your program should use mouth to speak stuff. Give him this ones.
  Mouth = Struct.new(:natural_voice, :debug_voice) do
    # Public: Says simple stuff with formatted parameters.
    def say(msg, *args)
      natural_voice.puts(msg, *args)
    end

    # Public: Debug information print. Uses secondary, debug voice output.
    def debug(msg, *args)
      debug_voice.puts("DEBUG: #{msg}", *args)
    end
  end

  # Public: Incldue this stuff into your class to make it talkative.
  module Talkative
    def self.included(klass)
      klass.extend(Forwardable)
      klass.delegate([:say, :debug] => :mouth)
    end

    # Public: Configured mouth object.
    def mouth
      @mouth ||= Mouth.new(
        StreamVoice.new(STDERR),
        ENV['DEBUG'] == '1' ? StreamVoice.new(STDERR) : NullVoice.instance
      )
    end
  end
end
