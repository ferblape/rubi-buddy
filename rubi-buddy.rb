require 'usb'
 
class Array
  
  def to_string
    br = ''
    self.each do |i|
      br << (i&0xFF)
    end
    br
  end
  
end 

class RubiBuddy

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
    self.reset
  end
  
  def message_base
    MESSAGE.dup
  end
  
  def send(inc)
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (message_base << inc).to_string, 0)
  end
  
  def activate_hearth
    send(RESET ^ 0x80)
  rescue
  end
  
  def color(red, green, blue)
    r = red << 4
    g = green << 5
    b = blue << 6
    send(RESET ^ (r | g | b))
  rescue
  end
  
  def reset
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.to_string, 0)
    send(RESET)
  rescue
  end

  # TODO  
  def flap(times = 2)    
    bits = [0x08, 0x04]
    1.upto(times) do |i|
      index  = i%2
      send(0xFF ^ (bits[1]))
    end
    # send(RESET ^ (bits[0] | bits[1]))
    # send(RESET ^ (bits[1] | bits[0]))
  end
  
  def turn(direction)
    # left
    if direction == 0 
      send(RESET ^ 0x01)
    elsif direction == 1
      send(RESET ^ 0x02)
    end
    sleep 1
  rescue
  end
  
end
