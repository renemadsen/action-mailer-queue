module ActionMailer
  class Queue < ActionMailer::Base

    @@table_name = 'emails'
    cattr_accessor :table_name
    
    @@delivery_method = :action_mailer_queue
    cattr_accessor :delivery_method
  
    @@limit_for_processing = 100
    cattr_accessor :limit_for_processing
    
    @@max_attempts_in_process = 5
    cattr_accessor :max_attempts_in_process
    
    @@delay_between_attempts_in_process = 240
    cattr_accessor :delay_between_attempts_in_process

    @@destroy_message_after_deliver = false
    cattr_accessor :destroy_message_after_deliver

    @@approved = false
    cattr_accessor :approved

    @@scheduled_time = '09:00:00'
    cattr_accessor :scheduled_time

    @@immediately_delivery = false
    cattr_accessor :immediately_delivery
  
    def self.queue
      return new.queue
    end
  
    def queue
      return Store.create_by_table_name(ActionMailer::Queue.table_name)
    end
  
    def perform_delivery_action_mailer_queue(mail)
      store = self.queue.new(:tmail => mail, :method =>  "#{mailer_name}.#{@template}", :approved => approved, :scheduled_time => scheduled_time, :immediately_delivery => immediately_delivery)
      store.save
      mail.queue_id = store.id
      return true
    end
 
  end
end