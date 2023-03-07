class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def stock(item, quantity)
      inventory[item] += quantity
  end

  def check_stock(item)
    inventory[item]
  end

  def potential_revenue
    pot_rev = 0.00
    @inventory.each do |item, quantity|
      pot_rev += item.price*quantity
    end
    pot_rev.round(2)
  end
end
