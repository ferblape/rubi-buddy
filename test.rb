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
  end
  
end 
 
bus = nil
device = nil

USB.devices.each do |dev|
 begin
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

def color(red, green, blue)
  res = 0xFF
  re = red << 4
  gr = green << 5
  bl = blue << 6
  res ^ (re | gr | bl)
end

# 00000000
# 1000 0000
# 0000 0 
# 0001 1
# 0010 2
# 0011 3
# 0100 4
# 0101 5
# 0110 6
# 0111 7
# 1000 8
# 1001 9
# 1010 10 - A
# 1011 11 - B
# 1100 12 - C
# 1101 13 - D
# 1110 14 - E
# 1111 15 - F

puts "Enviando datos"
ibuddy.open do |h|
  
  # puts "corazon:"
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (MESS.dup + [(RESET ^ 0x80)]).to_string, 0)

  sleep 1
  
  puts "reset:"
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (MESS.dup + [RESET]).to_string, 0)

  sleep 1 

  puts "cabeza roja:"
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (MESS.dup + [color(1,0,0)]).to_string, 0)

  sleep 1

  puts "reset:"
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
  h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (MESS.dup + [RESET]).to_string, 0)
end
