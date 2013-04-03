require 'spec_helper'

describe "HavingBook Model" do
  let(:having_book) { HavingBook.new }
  it 'can be created' do
    having_book.should_not be_nil
  end
end
