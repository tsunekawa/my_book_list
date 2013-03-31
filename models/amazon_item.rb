class AmazonItem < ActiveRecord::Base
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
    begin
      @item   = Amazon::Ecs.item_lookup(asin, :country=>:jp, :response_group=>"Medium").first_item
    rescue => ex
      logger.error ex
    end

    @looked = true
  end
end
