#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
class Book
  attr_accessor :title, :author, :publisher, :isbn, :asin

  def initialize(data)
    @title     = data[:title]
    @author    = data[:author]
    @publisher = data[:publisher]
    @isbn      = data[:isbn]
    @asin      = data[:asin]
  end

  def self.search(q, options=Hash.new)
    results = {:books=>Array.new }
    res = Amazon::Ecs.item_search(q, :country=>"jp")
    raise res.error if res.has_error?

    res.items.each do |item|
      results[:books] << self.new(
	:title => item.get('ItemAttributes/Title'),
	:author => item.get('ItemAttributes/Author')
      )
    end

    results
  end
end
