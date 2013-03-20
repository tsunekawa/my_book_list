#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
class Book
  attr_accessor :title, :author, :publisher, :isbn, :asin, :small_image, :medium_image, :url

  def initialize(data)
    @title     = data[:title]
    @author    = data[:author]
    @publisher = data[:publisher]
    @isbn      = data[:isbn]
    @asin      = data[:asin]
    @small_image      = data[:small_image]
    @medium_image     = data[:medium_image]
    @url       = data[:url]
  end

  def self.search(q, options=Hash.new)
    results = {:books=>Array.new }
    res = ::Amazon::Ecs.item_search(q, :country=>"jp", :response_group=>"Medium")
    raise res.error if res.has_error?

    res.items.each do |item|
      small_image = item.get_hash('SmallImage')
      small_image = Hash[ small_image.map {|k,v| [k.downcase.to_sym, v] } ] if small_image.present?

      medium_image = item.get_hash('MediumImage')
      medium_image = Hash[ medium_image.map {|k,v| [k.downcase.to_sym, v] } ] if medium_image.present?

      results[:books] << self.new(
	:title => item.get('ItemAttributes/Title'),
	:author => item.get('ItemAttributes/Author'),
	:publisher => item.get('ItemAttributes/Manufacturer'),
	:isbn => item.get('ItemAttributes/EAN'),
	:small_image => small_image,
	:medium_image => medium_image,
	:url => item.get('DetailPageURL')
      )
    end

    results
  end

end
