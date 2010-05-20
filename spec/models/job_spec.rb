require File.dirname(__FILE__) + '/../spec_helper'

describe Job do
  it "should be valid" do
    Job.new.should be_valid
  end
end
