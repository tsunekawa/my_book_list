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
end
