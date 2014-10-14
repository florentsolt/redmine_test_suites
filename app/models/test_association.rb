class TestAssociation < ActiveRecord::Base
  belongs_to :case, :class_name => 'TestCase', :foreign_key => 'test_case_id'
  belongs_to :suite, :class_name => 'TestSuite', :foreign_key => 'test_suite_id'
  belongs_to :nested_suite, :class_name => 'TestSuite', :foreign_key => 'nested_test_suite_id'
  belongs_to :user

  before_save :check_order

  private

  def check_order
    if self.order.nil?
      self.order = TestAssociation.count(:conditions => {:test_suite_id => self.suite.id}) + 1
    end
  end
end
