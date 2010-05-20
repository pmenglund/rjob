class ExecutionsController < ApplicationController
  def index
    @executions = Execution.all
  end
  
  def show
    @execution = Execution.find(params[:id])
  end
  
  def new
    @execution = Execution.new
  end
  
  def create
    @execution = Execution.new(params[:execution])
    if @execution.save
      flash[:notice] = "Successfully created execution."
      redirect_to @execution
    else
      render :action => 'new'
    end
  end
  
  def edit
    @execution = Execution.find(params[:id])
  end
  
  def update
    @execution = Execution.find(params[:id])
    if @execution.update_attributes(params[:execution])
      flash[:notice] = "Successfully updated execution."
      redirect_to @execution
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @execution = Execution.find(params[:id])
    @execution.destroy
    flash[:notice] = "Successfully destroyed execution."
    redirect_to executions_url
  end
end
