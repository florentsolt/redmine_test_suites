class TestCase < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_many :associations, :class_name => 'TestAssociation'
  has_many :suites, :class_name => 'TestSuite', :through => :associations
  has_and_belongs_to_many :issues, :join_table => :test_issues, :order => 'test_issues.created_at ASC'
  has_many :logs, :class_name => 'TestLog', :order => 'test_logs.created_at DESC'
  has_many :last_logs, :class_name => 'TestLog', :order => 'test_logs.created_at DESC', :limit => 10, :include => {:execution => :suite}
  acts_as_attachable :view_permission => :view_tests, :delete_permission => :edit_tests
  belongs_to :user

  safe_attributes 'title', 'description', 'steps', 'preconditions', 'postconditions'

  before_create :strip
  before_save :strip

  before_destroy {|kase| TestAssociation.delete_all([
    "test_case_id = ?", kase.id
  ])}

  def project
    # For attachments to work :(
    nil
  end

  def last_log
    @last_log ||= self.logs.limit(1).first
  end

  private

  def strip
    self.title = self.title.strip
  end

end
