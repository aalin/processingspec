require File.join(File.dirname(__FILE__), '../spec_helper')

class Fail
end

describe Fail do
  100.times do
    case rand(3)
    when 0
      it('should fail') { true.should be_false }
    when 1
      it('should win') { true.should be_true }
    else
      it('should be pending')
    end
  end
end
