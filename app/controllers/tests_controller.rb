class TestsController < ApplicationController

  before_filter :authorize_global

  def index
    conditions = {:archived => false}
    conditions.delete :archived  if params[:archived]
    conditions[:executable] = true if params[:only_executable]
    @suites = TestSuite.find(:all, :conditions => conditions, :order => 'title ASC')
    @cases = TestCase.find(:all, :order => 'title ASC')
  end

  def logs
    per_page = params[:per_page].to_i
    per_page = 20 if per_page < 1

    page = params[:page].to_i
    page = 1 if page < 1

    @count = TestLog.count
    @pages = Paginator.new @count, per_page, page
    @logs = TestLog.order("created_at DESC").limit(per_page).offset(@pages.offset)
  end

  def executions
    per_page = params[:per_page].to_i
    per_page = 20 if per_page < 1

    page = params[:page].to_i
    page = 1 if page < 1

    @count = TestExecution.count
    @pages = Paginator.new @count, per_page, page
    @executions = TestExecution.order("created_at DESC").limit(per_page).offset(@pages.offset)
  end

end
