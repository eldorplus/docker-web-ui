require 'active_hash'

class Machine < NoModel
  attr_accessor :hostname, :uuid, :memory
  attr_accessor :processors, :processor_usage
  attr_accessor :status
  attr_accessor :vnc_password, :vnc_port
  attr_accessor :disks

  def self.all
    Vm::Machine.all
  end

  def self.find id
    Vm::Machine.find id
  end

  def id
    hostname
  end

  %w(start pause resume stop force_stop restart force_restart).each do |operation|
    define_method operation do
      Vm::Machine.send operation, id
    end
  end


  class Status < ActiveHash::Base
   
    self.data = [
        {id: :running, name: 'Running', running: true, icon: 'fa fa-play'},
        {id: :saved, name: 'Saved', running: false, icon: 'fa fa-stop'},
        {id: :suspended, name: 'Suspended', running: false, icon: 'fa fa-pause'},
        {id: :stopped, name: 'Stopped', running: false, icon: 'fa fa-stop'},
        {id: :unknown, name: 'Unknown', running: nil, icon: 'fa fa-question'}
    ]

    def stopped?
      running === false
    end

    def running?
      running
    end

    def to_s
      name
    end
  end
end
