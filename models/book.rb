#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
class Book < AmazonItem
  attr_accessor :title, :author, :publisher, :isbn, :small_image, :medium_image, :url,:ndc

  def self.search(q, options=Hash.new)
    page = options[:page] || 1
    res = ::Amazon::Ecs.item_search(q, :country=>"jp", :response_group=>"Medium", :item_page=>page)
    raise res.error if res.has_error?

    res.items.map do |item|
      self.new(:asin=>item.get('ASIN'))
    end
  end

  def self.cache_all
    n = 0 
    find_each do |b|
      next if b.cached?
      begin
        title = b.title
      rescue
        logger.info "fail: asin:#{b.asin}"
        sleep 3
        next
      end
      n+=1
      logger.info "[#{n}] cached: #{title}"
      sleep 0.5
    end
    logger.info "complete! cached #{n} books!"
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

  def ndc
    unless @ndc ||= @@cache.get("#{isbn}:ndc")
      result = NDLSearch::NDLSearch.new.search(:isbn=>isbn,:cnt=>1)
      @ndc = result.items.first.try(:ndc)
      @@cache.set("#{isbn}:ndc", @ndc)
    end

    @ndc
  end
end
