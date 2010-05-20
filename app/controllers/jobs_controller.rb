class JobsController < ApplicationController
    def index
        @jobs = Job.find(:all, :order =>'created_at DESC')
    end
  
    def show
        @job = Job.find(params[:id])
    end

    def retry
        @job = Job.find(params[:id])
        count = 0
        @job.executions.each do |e|
            if e.result.nil?
                Delayed::Job.enqueue e
                Rjob.info("execution #{e.id} enqueud again")
                count += 1
            end
        end
        flash[:notice] = "Successfully enqueued #{count} failed executions"
        redirect_to @job
    end

    def rerun
        old = Job.find(params[:id])
        @job = old.clone
        @job.created_at = nil
        @job.updated_at = nil
        @job.title << " (rerun of job #{old.id})"
        if @job.save
            flash[:notice] = "Successfully created new job with id #{@job.id}"
        else
            flash[:notice] = "Failed to rerun job"
        end
        redirect_to @job
    end

    def new
        @job = Job.new
    end
  
    def create
        @job = Job.new(params[:job])
        if @job.save
            flash[:notice] = "Successfully created job."
            redirect_to @job
        else
            render :action => 'new'
        end
    end
  
    def edit
        @job = Job.find(params[:id])
    end
  
    def update
        @job = Job.find(params[:id])
        if @job.update_attributes(params[:job])
            flash[:notice] = "Successfully updated job."
            redirect_to @job
        else
            render :action => 'edit'
        end
    end
  
    def destroy
        @job = Job.find(params[:id])
        @job.destroy
        flash[:notice] = "Successfully destroyed job."
        redirect_to jobs_url
    end
end
