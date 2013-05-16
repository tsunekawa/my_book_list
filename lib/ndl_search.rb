#-*- coding:utf-8 -*-

require "rexml/document"
require 'rest-client'
require 'uri'
require 'nkf'

module NDLSearch
  VERSION  = File.open(File.join(File.dirname(__FILE__), %w{ .. VERSION })).read
  API_PATH = "http://iss.ndl.go.jp/api/opensearch"

  class NDLSearch
    attr_accessor :feed

    def initialize
      @feed = nil
    end

    def search(query)
      source = RestClient.get(construct_query(query))
      ::NDLSearch::SearchResult.new(::REXML::Document.new(source))
    end

    def construct_query(query)
      url = API_PATH+"?"+create_params(query)
      URI.escape(url)
    end

    def create_params(hash)
      hash.to_a.map{|item| "#{item[0]}=#{item[1]}"}.join("&")
    end
  end

  class SearchResult
    attr_accessor :resource

    def initialize(xml)
      @resource = xml
    end

    def item
      items.first
    end

    def items
      @items ||= @resource.get_elements('/rss/channel/item').map{|item| ::NDLSearch::Item.new(item) }
    end
  end

  class Item
    attr_accessor :resource

    def initialize(xml)
      @resource = xml
    end

    def title
      @title ||= @resource.get_text('title')
    end

    def permalink
      @guid ||=  @resource.get_text('guid')
    end

    def ndc
      ndc = @resource.get_text('dc:subject[@xsi:type="dcndl:NDC9"]')
      ndc = @resource.get_text('dc:subject[@xsi:type="dcndl:NDC"]') if ndc=="" or ndc.nil?
      if ndc=="" or ndc.nil? then
        binding.pry
        value = @resource.get_text('//dcterms:subject/@rdf:resource')
        ndc   = value.nil? ? nil: value.scan(/ndc9\/(.*)/).first.first
      end

      @ndc ||= NKF.nkf('-m0Z1 -w', ndc.to_s)
    end
  end
end
