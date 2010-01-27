require File.join(File.dirname(__FILE__), '../spec_helper')

class Fail
end

describe Fail do
  100.times do
    if (rand(10) % 3).zero?
      it('should fail') { true.should be_false }
    else
      it('should win') { true.should be_true }
    end
  end
end
