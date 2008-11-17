require 'usb'
require 'pp'
 
# class iBuddy
#   
#   idVendor = 1130
#   idProduct = 0002
#   
# end

class Array
  
  def to_string
    br = ''
    self.each do |i|
      br << (i&0xFF)
    end
    br
    # br.reverse!
  end
  
end 
 
# dev = USB.find_bus(4).find_device(1)

bus = nil
device = nil

USB.devices.each do |dev|
 begin
   # puts ("%04x:%04x" % [dev.idVendor, dev.idProduct])
   # puts dev.inspect
   if '1130' == ("%04x" % dev.idVendor) &&
      '0002' == ("%04x" % dev.idProduct)
      bus = dev.bus.dirname
      device = dev.filename
   end
 rescue
 end
end

ibuddy = nil

if bus.nil? && device.nil?
  puts "No se ha encontrado el iBuddy"
  exit -1
else
  ibuddy = USB.find_bus(bus.to_i).find_device(device.to_i)
  puts "Conectando a iBuddy"
end

USB_RT_PORT = USB::USB_TYPE_CLASS | USB::USB_RECIP_OTHER
USB_PORT_FEAT_POWER = 8

# envío de un paquete
# 
# SETUP   = (0x22, 0x09, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00)
# MESS    = (0x55, 0x53, 0x42, 0x43, 0x00, 0x40, 0x02)
# 
# self.dev.handle.controlMsg(0x21, 0x09, self.SETUP, 0x02, 0x01)
# self.dev.handle.controlMsg(0x21, 0x09, self.MESS+(inp,), 0x02, 0x01)
# 
SETUP   = [0x22, 0x09, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00]
MESS    = [0x55, 0x53, 0x42, 0x43, 0x00, 0x40, 0x02]
RESET   = 0xFF
# 
# message = MESS << (0xFF ^ 4)

# i = num
# br=''
# 4.times{
# br << (i&0xFF)
# i >>= 8
# }
# br.reverse!

# Python
# 
# def controlMsg               (requestType, request, buffer, value = 0, index = 0, timeout = 100)

# Ruby
#
# USB::DevHandle#usb_control_msg(requesttype, request, value, index, bytes, timeout)
# h.usb_control_msg(USB_RT_PORT, USB::USB_REQ_SET_FEATURE, USB_PORT_FEAT_POWER, port, "", 0)

puts "Enviando datos"
ibuddy.open do |h|
  puts 'SETUP:'
  # SETUP.each do |v|
  #   h.usb_control_msg(0x21, 0x09, 0x02, 0x01, v[0].chr, 0)
  #   putc '.'
  # end
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
  puts "\nMESS:"
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, MESS.to_string, 0)
  # h.usb_control_msg(0x21, 0x09, SETUP, 0x02, 0x01)
  # h.usb_control_msg(0x21, 0x09, message, 0x02, 0x01)
  puts "\nFinalizando"

  # h.usb_control_msg(0x21, 0x09, 0x02, 0x01, RESET.to_string, 0)
  h.reset
  
end


# Scan the usb busses for something with vendorid=0×1130 and prodid=0×0002 - thats the ibuddy

# #<USB::Device 007/005-1130-0002-00-00 1130:0002 i-Buddy ? (HID (00,00), HID (00,00))>
