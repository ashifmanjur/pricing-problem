class PriceCalculator
  attr_accessor :base_price, :mark_ups

  def initialize(base_price = 0, mark_ups = [])
    self.base_price = base_price || 0
    self.mark_ups = mark_ups || []
  end
end