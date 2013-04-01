class AmazonItem < ActiveRecord::Base
  CACHE_SERVERS = 'localhost:11211'
  @@cache = Dalli::Client.new(CACHE_SERVERS, :expires_in => 3600 * 24)
  validates_presence_of :asin

  def get(path)
    lookup unless @looked
    @item.get(path)
  end

  def get_hash(path)
    lookup unless @looked
    @item.get_hash(path)
  end

  protected

  def validate
    lookup unless @looked
    errors.add :asin, "can't find the item from Amazon" unless @item
  end

  private

  def lookup
    if @item = @@cache.get(asin)
      @item  = Amazon::Element.new Nokogiri::XML(@item, nil, 'UTF-8').elements
    elsif @item = Amazon::Ecs.item_lookup(asin, :country=>:jp, :response_group=>"Medium").first_item
      @@cache.set(asin, @item.to_s)
    end

    @looked = true
  rescue => ex
    logger.error ex
  end
end
