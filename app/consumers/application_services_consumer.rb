class ApplicationServicesConsumer < Racecar::Consumer
  subscribes_to "applicationServices"

  def process(message)
    puts "-------------#{message.value}--------------------"
    array = message.value.split('-->')
    if array.first == "PATCH"
      values = eval(array.second)
      order = Order.find(values[:order_id])
      status = values[:driver_id].to_s.empty? ? 3 : 1
      order.update(driver_id: values[:driver_id], status: status)

    elsif array.first == "UPDATEGOPAY"
      values = eval(array.second)
      user_type = values[:user_type]
      user = user_type.constantize.find(values[:user_id])

      user.valid?
      puts "#{user.errors.full_messages}"
      user.update(gopay:values[:credit])
      puts "#{user.errors.full_messages}"
      
    end

    sleep(5)
  end


end
