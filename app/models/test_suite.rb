class TestSuite < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_many :associations, -> { order('test_associations.`order` ASC').includes(:case, :nested_suite) }, :class_name => 'TestAssociation'
  has_many :executions, -> { order('test_executions.created_at DESC') }, :class_name => 'TestExecution'
  has_many :last_executions, -> { order('test_executions.created_at DESC').includes(:logs).limit(10) }, :class_name => "TestExecution"
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

