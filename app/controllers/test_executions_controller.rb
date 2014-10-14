class TestExecutionsController < ApplicationController
  before_filter :authorize_global
  before_filter :find_execution, :only => [:show]

  helper :tests

  def show
  end

  private

  def find_execution
    @execution = TestExecution.find(params[:id], :include => {:logs => :case})
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end

