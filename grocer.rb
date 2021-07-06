require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
      item.each do |name, stats|
          stats[:count] = cart.count(item)
          new_cart[name] ||= stats
          end
      end
  new_cart
end

def apply_coupons(cart, coupons)
    new_cart = {}
    cart.each do |item, stats|
    coupons.each do |i|
        if item == i[:item] && stats[:count] >= i[:num]
            stats[:count] = stats[:count] - i[:num]
            if new_cart["#{item} W/COUPON"]
                new_cart["#{item} W/COUPON"][:count] += 1
            else
#            binding.pry
                new_cart["#{item} W/COUPON"] = {:price=>i[:cost], :clearance=>stats[:clearance], :count=>1}
            end
        end
    end
    new_cart[item] = stats
    end
#    binding.pry
    new_cart
end

def apply_clearance(cart)
    cart.each do |item,stats|
        if stats[:clearance] == true
            stats[:price] = (stats[:price] * 0.8).round(2)
        end
    end
    cart
end

def checkout(cart, coupons)
    cart = consolidate_cart(cart)
    cart = apply_coupons(cart, coupons)
    cart = apply_clearance(cart)
    
    total = 0
    cart.each do |item, stats|
        total += stats[:price] * stats[:count]
    end
    if total > 100
        total = (total * 0.9).round(2)
#    binding.pry
    end
    total
end
