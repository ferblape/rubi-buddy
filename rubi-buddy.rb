require 'usb'
 
class Array
  
  def bytes_to_string
    br = ''
    self.each do |i|
      br << (i&0xFF)
    end
    br
  end
  
end 

class RubiBuddy

  # Setup bytes
  SETUP   = [0x22, 0x09, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00]
  # Base message bytes
  MESSAGE = [0x55, 0x53, 0x42, 0x43, 0x00, 0x40, 0x02]
  # Reset
  RESET   = 0xFF
  
  attr_reader :h

  def initialize
    # Search for the device
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

    # Load the device
    dev = if bus.nil? && device.nil?
      raise "i-Buddy not found. Please connect it or try again"
    else
      USB.find_bus(bus.to_i).find_device(device.to_i)
    end
    # Prepare a handler
    @h = dev.usb_open
    # Reset the i-Buddy state
    self.reset
  end
  
  def message_base
    MESSAGE.dup
  end
  
  # Basic method for sending messages
  def send(inc)
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, (message_base << inc).bytes_to_string, 0)
  end
  
  # Reset message
  def reset
    @h.usb_control_msg(0x21, 0x09, 0x02, 0x01, SETUP.bytes_to_string, 0)
    send(RESET)
  rescue
  end
  
  # Turn on the hearth
  def activate_hearth
    send(RESET ^ 0x80)
  rescue
  end
  
  # Change its head colour
  def color(red, green, blue)
    r = red << 4
    g = green << 5
    b = blue << 6
    send(RESET ^ (r | g | b))
  rescue
  end
  
  # Move flaps up and down
  def flaps(times = 5)
    bits = [0x08, 0x04]
    1.upto(times) do |i|
      begin
        send(RESET ^ (bits[i%2]))
      rescue
      end
      sleep 0.4
    end    
  end
  
  # Makes the i-Buddy turn left or right. The sleep is necessary because
  # the movement takes some time to end
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
