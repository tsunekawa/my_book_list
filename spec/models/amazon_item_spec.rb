require 'spec_helper'

describe "AmazonItem Model" do
  let(:amazon_item) { AmazonItem.new }
  it 'can be created' do
    amazon_item.should_not be_nil
  end
end
