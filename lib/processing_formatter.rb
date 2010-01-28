require 'rubygems'
require 'ruby-processing'
require 'spec/runner/formatter/base_formatter'

module Processing ; SKETCH_PATH = __FILE__ ; end

class SpecSketch < Processing::App
  load_library :opengl

  class Cube
    attr_accessor :status
    attr_accessor :rotation

    def initialize(rotation = 0.0)
      @rotation = rotation
    end

    def draw
      case self.status
      when :passed
        fill(0.0, 1.0, 0.0)
      when :failed
        fill(1.0, 0.0, 0.0)
      when :pending
        fill(1.0, 1.0, 0.0)
      else
        fill(0.3, 0.3, 0.3)
      end

      push_matrix
        rotate(@rotation)
        box 40
      pop_matrix
    end
  end

  attr_reader :number_of_examples

  def setup
    smooth
    no_stroke
    frame_rate 30
    color_mode RGB, 1
    render_mode(OPENGL)

    reset_number_of_examples!(0)
  end
  
  def reset_number_of_examples!(num)
    @number_of_examples = num
    puts @number_of_examples
    @results = []
  end

  def add_result!(result)
    @results << result
  end

  def draw
    background(0)

    lights
    examples_per_row = Math::sqrt(number_of_examples).ceil
    puts number_of_examples
    number_of_examples.times do |i|
      x = (i % examples_per_row) * self.width / examples_per_row.to_f
      y = (i / examples_per_row) * self.height / examples_per_row.to_f
      puts x
      push_matrix
        translate(x, y)
        Cube.new(0.0).draw 
      pop_matrix
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
