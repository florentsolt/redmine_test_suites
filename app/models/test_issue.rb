class TestIssue < ActiveRecord::Base
  belongs_to :case, :class_name => 'TestCase', :foreign_key => 'test_case_id'
  belongs_to :issue
  belongs_to :user
end
