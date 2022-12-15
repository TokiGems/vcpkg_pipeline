# frozen_string_literal: true

# VPL
module VPL
  def self.attribute_str(msg, type)
    "\n\033[#{type}m#{msg}\033[0m\n"
  end

  def self.title(msg)
    puts attribute_str("-- #{msg} --", 44)
  end

  def self.info(msg)
    puts attribute_str(msg, 46)
  end

  def self.error(msg)
    raise attribute_str("Error: #{msg}!", 41)
  end
end
