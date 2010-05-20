require File.dirname(__FILE__) + '/../spec_helper'

describe Execution do
  it "should be valid" do
    Execution.new.should be_valid
  end
end
