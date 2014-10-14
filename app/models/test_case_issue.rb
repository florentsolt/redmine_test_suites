class TestCaseIssue < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :issue
  belongs_to :user

  def case
    self.test_case
  end
end
