require 'usb'
require 'pp'
 
class Array
  
  def to_string
    br = ''
    self.each do |i|
      br << (i&0xFF)
    end
    br
  end
  
end 

class IBuddy

  SETUP   = [0x22, 0x09, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00]
  MESSAGE = [0x55, 0x53, 0x42, 0x43, 0x00, 0x40, 0x02]
  RESET   = 0xFF
  
  attr_reader :h

  def initialize
    bus, device = nil, nil
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

    dev = if bus.nil? && device.nil?
      raise "No se ha encontrado el iBuddy. Vuelve a intentarlo"
    else
      USB.find_bus(bus.to_i).find_device(device.to_i)
    end
    @h = dev.usb_open
  end
  
  def message_base
    MESSAGE.dup
  end
  
  def reset_message
    RESET
  end
  
  def send(inc)
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (message_base << inc).to_string, 0)
  end
  
  def activate_hearth
    send(reset_message ^ 0x80)
  end
  
  def reset
    send(0xFF)
  end
  
end

ibuddy = IBuddy.new
ibuddy.reset
# ibuddy.activate_hearth
# sleep 2
# ibuddy.reset