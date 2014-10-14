class TestSuite < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_many :associations, :class_name => 'TestAssociation', :order => 'test_associations.`order` ASC', :include => [:case, :nested_suite]
  has_many :executions, :class_name => 'TestExecution', :order => 'test_executions.created_at DESC'
  has_many :last_executions, :class_name => "TestExecution", :limit => 10, :order => 'test_executions.created_at DESC', :include => :logs
  belongs_to :user

  safe_attributes 'title'

  before_create :strip
  before_save :strip

  before_destroy {|suite| TestAssociation.delete_all([
      "test_suite_id = ? OR nested_test_suite_id = ?",
      suite.id, suite.id
  ])}

  def strip
    self.title = self.title.strip
  end

  def cases
    @cases||= associations.map do |association|
      association.case || association.nested_suite.cases
    end.flatten.uniq
  end

  def nested_suites
    associations.map(&:nested_suite).compact
  end

  def available_for_association
    if self.cases.any?
      available = TestCase.find(:all,
        :conditions => ["id NOT IN (?)", self.cases],
        :include => :suites
      )
    else
      available = TestCase.find(:all,
        :include => :suites
      )
    end
    available + TestSuite.find(:all, :conditions => ["archived = ? AND executable = ? AND id NOT IN (?)", false, true, [self] + self.nested_suites.map(&:id)])
  end

end

