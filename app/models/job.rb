class Job < ActiveRecord::Base
    has_many :executions, :dependent => :destroy
    has_many :pending_executions, :class_name => 'Execution', :conditions => {:status => 0}
    has_many :running_executions, :class_name => 'Execution', :conditions => {:status => 1}
    has_many :finished_executions, :class_name => 'Execution', :conditions => {:status => 2}
    after_create :submit_jobs
    attr_accessible :title, :command, :hosts, :user
    validates_presence_of :hosts, :user, :command

    protected
    
    def submit_jobs
        hosts.split(/,/).each do |host|
            e = Execution.new(:job_id => id, :host => host)
            e.save
            Delayed::Job.enqueue e
            Rjob.info("execution #{e.id} enqueued")
        end
    end
end
