class NdlItem < ActiveRecord::Base
  validates_uniqueness_of :isbn

  def self.lookup(isbn)
    raise ArgumentError, "isbn is blank " if isbn.blank?
    unless item = self.where(:isbn=>isbn).first
      result = NDLSearch::NDLSearch.new.search(:isbn=>isbn,:cnt=>1)
      item   = result.items.first
      item = NdlItem.create(
        :isbn=>isbn.to_s,
        :ndc=>item.try(:ndc).try(:to_s)
      )
    end
    item
  end
end
