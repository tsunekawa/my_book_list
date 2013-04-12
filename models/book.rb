#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
class Book < AmazonItem
  attr_accessor :title, :author, :publisher, :isbn, :small_image, :medium_image, :url

  def self.search(q, options=Hash.new)
    page = options[:page] || 1
    res = ::Amazon::Ecs.item_search(q, :country=>"jp", :response_group=>"Medium", :item_page=>page)
    raise res.error if res.has_error?

    res.items.map do |item|
      self.new(:asin=>item.get('ASIN'))
    end
  end

  def small_image
    if @small_image.blank? then
       _small_image = get_hash('SmallImage')
       @small_image = Hash[ _small_image.map {|k,v| [k.downcase.to_sym, v] } ] if _small_image.present?
    end
    @small_image
  end

  def medium_image
    if @medium_image.blank? then
      _medium_image = get_hash('MediumImage')
      @medium_image = Hash[ _medium_image.map {|k,v| [k.downcase.to_sym, v] } ] if _medium_image.present?
    end
    @medium_image
  end

  def title
    @title ||= get('ItemAttributes/Title')
  end

  def author
    @author ||= get('ItemAttributes/Author')
  end
  
  def publisher
    @publisher ||= get('ItemAttributes/Manufacturer')
  end

  def isbn
    @isbn ||= get('ItemAttributes/EAN')
  end

  def url
    @url ||= get('DetailPageURL')
  end

end
