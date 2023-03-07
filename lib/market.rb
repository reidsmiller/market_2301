class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end
  
  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.select {|vendor| vendor.inventory.include?(item)}
  end

  def sorted_item_list
    list = @vendors.map {|vendor| vendor.inventory.keys}
    names = list.flatten.map(&:name)
    names.uniq!.sort
  end

  def total_quantity(item)
    quantity = 0
    @vendors.each {|vendor| quantity += vendor.check_stock(item)}
    quantity
  end

  def total_inventory
    list = @vendors.map {|vendor| vendor.inventory.keys}.flatten.uniq!
    t_inventory = {}
    list.each do |item|
      t_inventory[item] = {
        quantity: total_quantity(item),
        vendors: vendors_that_sell(item)
      }
    end
    t_inventory
  end

  def overstocked_items
    overstocked = []
    t_inventory = total_inventory
    t_inventory.each do |item, values|
      if values[:quantity] > 50 && values[:vendors].length > 1
        overstocked << item
      end
   end
   overstocked
  end

  def sell_inventory(input_item, quantity)
    until quantity == 0
      @vendors.each do |vendor|
        if vendor.inventory.include?(input_item) && vendor.check_stock(input_item) > 0
          if vendor.check_stock(input_item) >= quantity 
            vendor.inventory[input_item] -= quantity
            quantity = 0
          else
            quantity -= vendor.check_stock(input_item)
            vendor.inventory[input_item] = 0
          end
        end
      end
    end
  end

  def sell(input_item, quantity)
    t_inventory = total_inventory
    if t_inventory[input_item][:quantity] >= quantity
      sell_inventory(input_item, quantity)
      return true
    end
    false
  end
end
