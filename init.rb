Redmine::Plugin.register :redmine_test_suites do
  name 'Redmine Test Suites plugin'
  author 'Florent Solt'
  description 'Cross-project test Suites'
  version '0.0.1'
  url 'https://github.com/florentsolt/redmine_test_suites'

  project_module :tests do
    permission :view_tests, {
      :tests => [:index, :executions, :logs],
      :test_cases => [:show],
      :test_suites => [:show],
      :test_executions => [:show]
    }, :require => :member

    permission :edit_tests, {
      :test_cases => [:new, :create, :edit, :update, :destroy, :issue, :auto_complete, :preview],
      :test_suites => [:new, :create, :edit, :update, :destroy, :associate, :dissociate, :archive, :unarchive, :enable, :disable]
    }, :require => :member

    permission :run_tests, {
      :test_suites => [:execute, :next],
      :test_cases => [:execute, :log]
    }
  end

  menu :top_menu, :tests, { :controller => 'tests', :action => 'index' }, :caption => 'Tests'

end

# Add relation between models: Issue <-> TestCase
module TestSuites_IssuePatch
  def self.included(base)
    base.class_eval do
      has_and_belongs_to_many :cases, :class_name => 'TestCase', :join_table => :test_issues, :order => 'test_issues.created_at ASC'
    end
  end
end
require_dependency "issue"
Issue.send(:include, TestSuites_IssuePatch)


# Add test helpers in IssueController for partial views
module TestSuites_IssuesControllerPatch
  def self.included(base)
    base.class_eval do
      helper :tests
    end
  end
end
require_dependency "issues_controller"
IssuesController.send(:include, TestSuites_IssuesControllerPatch)

# Add javascript and stylesheet tags
class TestSuitesViewListener < ::Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    stylesheet_link_tag("test_suites.css", :plugin => "redmine_test_suites", :media => "screen")
  end
end

# Render case list in issue
class TestSuitesViewListener < ::Redmine::Hook::ViewListener
  render_on(:view_issues_show_description_bottom, :partial => 'issues/cases')
end
