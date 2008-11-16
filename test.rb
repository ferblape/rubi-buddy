require 'usb'
require 'pp'
 
 
# dev = USB.find_bus(4).find_device(1)
USB.devices.each do |dev|
  begin
    puts dev.inspect
  rescue
  end
end

# Scan the usb busses for something with vendorid=0×1130 and prodid=0×0002 - thats the ibuddy
