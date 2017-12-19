class ApplicationServicesConsumer < Racecar::Consumer
  subscribes_to "applicationServices"

  def process(message)
    array = message.value.split('-->')
    if array.first == "PATCH"
      order_value = eval(array.second)
      order = Order.find(order_value[:order_id])
      status = 0
      if order_value[:driver_id].to_s.empty?
        status = 3
      else
        status = 1
      end

      order.update(driver_id: order_value[:driver_id], status: status)
    end
    puts "-----------------------------#{message.value}--------------------------------"
    puts "-----------------------------#{message.value}--------------------------------"
    puts "-----------------------------#{message.value}--------------------------------"
    puts "-----------------------------#{message.value}--------------------------------"
    sleep(5)
  end


end
