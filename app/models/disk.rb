require 'active_hash'

class Disk < NoModel
  attr_accessor :path, :name, :format
  attr_accessor :size, :used
  attr_accessor :device, :pool


  def self.all
    Vm::Machine.all
  end

  def self.find id
    Vm::Machine.find id
  end

  def id
    hostname
  end

  %w(snapshot delete).each do |operation|
    define_method operation do
      # Vm::Disk.send operation, id
      raise
    end
  end
end