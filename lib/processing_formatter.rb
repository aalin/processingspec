require 'rubygems'
require 'ruby-processing'
require 'spec/runner/formatter/base_formatter'

module Processing ; SKETCH_PATH = __FILE__ ; end

class SpecSketch < Processing::App
  full_screen
  load_library :opengl

  class Cube
    attr_accessor :status
    attr_accessor :rotation
    attr_accessor :animation_counter

    def initialize
      @status = status
      @animation_counter = 0
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
        rotate(@animation_counter / 10.0, @animation_counter / 10.0, 0.0, 0.0)
        box 40 + @animation_counter * 5
      pop_matrix

      @animation_counter -= 1 if @animation_counter > 0
    end
  end

  attr_reader :number_of_examples

  def setup
    smooth
    no_stroke
    frame_rate 30
    color_mode RGB, 1
    render_mode(OPENGL)
  end
  
  def reset_number_of_examples!(num)
    @number_of_examples = num
    puts "#{num} #{ caller.inspect }"
    @results = []
    @cubes = Array.new(num) { Cube.new }
  end

  def add_result!(result)
    @results << result
    cube = @cubes[@results.size - 1]
    cube.status = result
    cube.animation_counter = 10
  end

  def draw
    background(0)

    return unless number_of_examples

    lights
    examples_per_row = Math::sqrt(number_of_examples).ceil
    box_width = self.width / examples_per_row.to_f
    box_height = self.height / examples_per_row.to_f
    @cubes.each_with_index do |cube, i|
      x = (i % examples_per_row) * box_width + 40
      y = (i / examples_per_row) * box_height + 40
      push_matrix
        translate(x, y)
        cube.draw
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

