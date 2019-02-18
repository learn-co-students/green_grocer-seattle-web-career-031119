require 'pry'

def consolidate_cart(cart)
  # code here
  result = {}
  cart.uniq.each do |item|
    item.values.first[:count] = cart.count(item)
    result[item.keys.first] = item.values.first
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.uniq.each do |coupon|
    if cart.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        counter = (cart[coupon[:item]][:count] / coupon[:num]).floor
        cart[coupon[:item]][:count] = cart[coupon[:item]][:count] % coupon[:num]
        newItem = coupon[:item] + " W/COUPON"
        cart[newItem] = {
          clearance: cart[coupon[:item]][:clearance],
          price: coupon[:cost],
          count: [counter, coupons.count(coupon)].min
        }
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance]
      details[:price] = (details[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  total = 0.0
  cart.each do |item, details|
    total += details[:price] * details[:count]
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
