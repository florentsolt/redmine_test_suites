class TestExecution < ActiveRecord::Base
  belongs_to :user
  belongs_to :suite, :class_name => 'TestSuite', :foreign_key => 'test_suite_id'
  has_many :logs, :class_name => 'TestLog', :order => 'test_logs.created_at ASC'

  def case?(kase)
    self.suite.cases.include? kase
  end

  def statuses
    {0 => [], 1 => [], 2 => [], 3 => []}.merge(logs.group_by(&:status))
  end

  def nexts
    done = logs.map(&:case)
    all = self.suite.cases
    all - done
  end

  def next
    nexts.first
  end

end
