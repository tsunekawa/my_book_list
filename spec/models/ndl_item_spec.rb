require 'spec_helper'

describe "NdlItem Model" do
  let(:ndl_item) { NdlItem.new }
  it 'can be created' do
    ndl_item.should_not be_nil
  end
end
