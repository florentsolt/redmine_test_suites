class TestCasesController < ApplicationController

  before_filter :find_case, :only => [:show, :edit, :update, :destroy, :execute, :log, :issue]
  before_filter :authorize_global

  helper :attachments
  helper :tests

  include AttachmentsHelper

  def new
    @case = TestCase.new
    @case.steps = "|_. Step|_. Action|_. Result|
| 1 | step 1 description | expected result |
| 2 | step 2 description | expected result |"
    render :form
  end

  def create
    @case = TestCase.new
    @case.safe_attributes = params[:test_case]
    @case.user = User.current
    @case.save_attachments(params[:attachments] || (params[:test_case] && params[:test_case][:uploads]))
    if @case.save
      flash[:notice] = "Case #{@case.id} successfully created"
      redirect_to :action => :show, :id => @case.id
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
    @case.safe_attributes = params[:test_case]
    @case.user = User.current
    @case.save_attachments(params[:attachments] || (params[:test_case] && params[:test_case][:uploads]))
    if @case.save
      flash[:notice] = "Case #{@case.id} successfully updated"
      redirect_to :action => :show, :id => @case.id
    else
      render :action => :edit
    end
  end

  def destroy
    @case.destroy
    redirect_to :controller => :tests, :action => :index
  end

  def execute
    @log = TestLog.new
    if cookies[:current_execution].nil?
      flash[:error] = "You can't execute this case withtout a suite"
      redirect_to :action => :show
    else
      @execution = TestExecution.find(cookies[:current_execution].to_i)
    end
  end

  def log
    if cookies[:current_execution].nil?
      flash[:error] = "You can't execute this case withtout a suite"
      redirect_to :action => :show
    else
      execution = TestExecution.find(cookies[:current_execution].to_i)
      if execution.user != User.current
        flash[:error] = "You can't execute this suite, it was started by an other user"
      end
      # TODO check suite executable?
      # TODO check if the case is in the suite
      if params['test_log']['status'].empty?
        flash[:error] = "You have to specify status"
        redirect_to :action => :execute
      else
        TestLog.create(:test_case_id => @case.id,
                       :status => params['test_log']['status'],
                       :comment => params['test_log']['comment'],
                       :test_execution_id => execution.id,
                       :user => User.current)
        redirect_to :action => :next, :controller => :test_suites, :id => execution.suite.id
      end
    end
  end

  def issue
    @issue = Issue.find(params[:issue_id].to_i)
    if request.delete?
      @case.issues.delete @issue
    elsif @issue.nil?
      notice[:error] = "Issue does not exists"
    else
      @relation = TestIssue.create(:case => @case,
                                   :issue => @issue,
                                   :user => User.current)
    end
    if params[:mode] == 'case'
      render 'issues/case'
    elsif params[:mode] == 'issue'
      render :issue
    else
      render :nothing => true
    end
  end

  def auto_complete
    # see AutoCompletesController#issues
    @cases = []
    q = (params[:q] || params[:term]).to_s.strip
    if q.present?
      if q.match(/\A#?(\d+)\z/)
        @cases << TestCase.find_by_id($1.to_i)
      end
      @cases += TestCase.where("LOWER(#{TestCase.table_name}.title) LIKE LOWER(?)", "%#{q}%").order("#{TestCase.table_name}.id DESC").limit(10).all
      @cases.compact!
    end
    render :layout => false
  end

  def preview
    @case = TestCase.new
    @case.safe_attributes = params[:test_case]
    render :layout => false
  end

  private

  def find_case
    @case = TestCase.find(params[:id] || params[:case_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
