require "pry"

def consolidate_cart(cart)

  new_hash = {}
  cart.each do |item_hash|
    item_hash.each do |item, values_hash|
      if new_hash.has_key?(item)
        new_hash[item][:count] += 1
      else
        new_hash[item] = values_hash
        new_hash[item][:count] = 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon_hash|
    
    if cart.has_key?(coupon_hash[:item]) && (cart[coupon_hash[:item]][:count] >= coupon_hash[:num])

      cart["#{coupon_hash[:item]} W/COUPON"] ||= {price: coupon_hash[:cost], clearance: cart[coupon_hash[:item]][:clearance]}

      #apply correct count to couponed item
      if cart["#{coupon_hash[:item]} W/COUPON"].has_key?(:count)
        cart["#{coupon_hash[:item]} W/COUPON"][:count] += 1
      else
        cart["#{coupon_hash[:item]} W/COUPON"][:count] = 1
      end

      #subtract couponed item from regular item
      cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, values_hash|
    if values_hash[:clearance] == true
      values_hash[:price] = (values_hash[:price]*0.8).round(1)
    end
  end
  cart
end

def checkout(cart, coupons)
  con_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(con_cart, coupons)
  clear_cart = apply_clearance(coup_cart)

#  !coupons.empty? ? binding.pry : nil

  total = 0
  clear_cart.each do |item, values_hash|
    total += values_hash[:price]*values_hash[:count]
  end

  total > 100 ? total = (total * 0.9).round(1) : nil
  total
end
