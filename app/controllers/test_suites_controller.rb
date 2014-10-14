class TestSuitesController < ApplicationController

  before_filter :find_suite, :only => [:show, :edit, :update, :destroy, :associate, :dissociate, :execute, :archive, :unarchive, :enable, :disable]
  before_filter :authorize_global

  helper :tests

  def new
    @suite = TestSuite.new
    render :form
  end

  def create
    @suite = TestSuite.new
    @suite.safe_attributes = params[:test_suite]
    @suite.user = User.current
    if @suite.save
      flash[:notice] = "Suite #{@suite.id} successfully created"
      redirect_to :action => :show, :id => @suite.id
    else
      render :action => :new
    end
  end

  def show
  end

  def edit
    render :form
  end

  def update
    @suite.safe_attributes = params[:test_suite]
    @suite.user = User.current
    if @suite.save
      flash[:notice] = "Suite #{@suite.id} successfully updated"
      redirect_to :action => :show, :id => @suite.id
    else
      render :action => :edit
    end
  end

  def destroy
    @suite.destroy
    redirect_to :controller => :tests, :action => :index
  end

  def associate
    if not params[:case].nil?
      # Associate a case in a suite
      begin
        TestAssociation.transaction do
          kase = TestCase.find(params[:case])
          TestAssociation.create(:suite => @suite, :case => kase, :user => User.current)
          flash[:notice] = "Case #{kase.id} successfully associated"
        end
      rescue ActiveRecord::RecordNotUnique
        flash[:error] = "The case #{params[:case]} is already associated"
      end
      redirect_to :action => :associate
      return
    elsif not params[:suite].nil?
      # Associate a suite in a suite
      begin
        TestAssociation.transaction do
          suite = TestSuite.find(params[:suite])
          TestAssociation.create(:suite => @suite, :nested_suite => suite, :user => User.current)
          flash[:notice] = "Suite #{suite.id} successfully associated"
        end
      rescue ActiveRecord::RecordNotUnique
        flash[:error] = "The suite #{params[:suite]} is already associated"
      end
      redirect_to :action => :associate
      return

    elsif not params[:order].nil?
      # Reorder cases
      params[:order].each_with_index do |item, index|
        TestAssociation.update(item.to_i, :order => index + 1)
      end
    end

    @available = @suite.available_for_association.group_by do |item|
      if item.class.to_s == "TestSuite"
        :suite
      elsif item.suites.empty?
        :unused
      else
        :used
      end
    end
    render :nothing => true if request.xhr?
  end

  def dissociate
    if not params[:case].nil?
      kase = TestCase.find(params[:case])
      TestAssociation.find(:first, :conditions => {:test_case_id => kase.id, :test_suite_id => @suite.id}).destroy
      flash[:notice] = "Case #{kase.id} successfully dissociated"
    end
    if not params[:suite].nil?
      suite = TestSuite.find(params[:suite])
      TestAssociation.find(:first, :conditions => {:nested_test_suite_id => suite.id, :test_suite_id => @suite.id}).destroy
      flash[:notice] = "Suite #{suite.id} successfully dissociated"
    end
    redirect_to :action => :associate
  end

  def execute
    if not cookies[:current_execution].nil?
      @execution = TestExecution.find(cookies[:current_execution].to_i)
      if @execution.suite.id != @suite.id
        flash[:warning] = "You dit not complete this suite"
        redirect_to :action => :show, :id => @execution.suite.id
      else
        redirect_to :action => :next
      end
    else
      execution = TestExecution.create(:test_suite_id => @suite.id, :user => User.current)
      cookies[:current_execution] = execution.id
      redirect_to :action => :next
    end

  end

  def next
    if not cookies[:current_execution].nil?
      @execution = TestExecution.find(cookies[:current_execution].to_i)
      @case = @execution.next
      if @case.nil?
        # Finished (or empty suite)
        cookies.delete :current_execution
        flash[:notice] = "The suite execution is complete"
        redirect_to :action => :show
      else
        # Run the next case
        redirect_to :action => :execute, :controller => :test_cases, :id => @case.id
      end
    else
      redirect_to :action => :show
    end
  end

  def archive
    @suite.archived = true
    @suite.save
    redirect_to :action => :show
  end

  def unarchive
    @suite.archived = false
    @suite.save
    redirect_to :action => :show
  end

  def enable
    @suite.executable = true
    @suite.save
    redirect_to :action => :show
  end

  def disable
    @suite.executable = false
    @suite.save
    redirect_to :action => :show
  end

  private

  def find_suite
    @suite = TestSuite.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end

