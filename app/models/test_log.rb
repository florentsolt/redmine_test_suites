class TestLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :execution, :class_name => 'TestExecution', :foreign_key => 'test_execution_id'
  belongs_to :case, :class_name => 'TestCase', :foreign_key => 'test_case_id'
  has_one :suite, :through => :execution

  before_create :check_status, :check_suite
  before_save :check_status, :check_suite

  STATUS = {
    0 => 'Not run',
    1 => 'Passed',
    2 => 'Blocked',
    3 => 'Failed'
  }

  private

  def check_status
    self.status = self.status.to_i
    if not STATUS.keys.include? self.status
      raise "Invalid :status for TestLog"
    end
    true
  end

  def check_suite
    if not self.execution.nil? and not self.execution.case? self.case
      raise "The case ##{self.case.id} is not associated with the suite ##{self.execution.suite.id}"
    end
    true
  end
  
end
