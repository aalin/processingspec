require 'rubygems'
require 'ruby-processing'
require 'spec/runner/formatter/base_formatter'

module Processing ; SKETCH_PATH = __FILE__ ; end

class SpecSketch < Processing::App
  attr_reader :number_of_examples

  def setup
    smooth
    no_stroke
    frame_rate 30
    color_mode RGB, 1

    reset_number_of_examples!(0)
  end
  
  def reset_number_of_examples!(num)
    @number_of_examples = num
    @results = []
  end

  def add_result!(result)
    @results << result
  end

  def draw
    background(0)

    if number_of_examples > 0
      example_width = self.width / number_of_examples.to_f

      number_of_examples.times do |i|
        case @results[i]
        when :passed
          fill(0.0, 1.0, 0.0)
        when :failed
          fill(1.0, 0.0, 0.0)
        when :pending
          fill(1.0, 1.0, 0.0)
        else
          fill(0.3, 0.3, 0.3)
        end

        x = i * example_width
        rect(x, 0, example_width, self.height)
      end
    end
  end
end

class ProcessingFormatter < Spec::Runner::Formatter::BaseFormatter
  def initialize(options, output)
    @sketch = SpecSketch.new(:width => 800, :height => 800, :title => "Spec Sketch")
  end

  def start(example_count)
    @sketch.reset_number_of_examples!(example_count)
  end

  def example_group_started(example_group_proxy)
  end

  def example_started(example_proxy)
    sleep 0.1
  end

  def example_passed(example_proxy)
    @sketch.add_result! :passed
  end

  def example_failed(example_proxy, counter, failure)
    @sketch.add_result! :failed
  end

  def example_pending(example_proxy, message, deprecated_pending_location=nil)
    @sketch.add_result! :pending
  end

  def close
    @sketch.close
  end
end
