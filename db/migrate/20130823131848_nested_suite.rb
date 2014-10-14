class NestedSuite < ActiveRecord::Migration
  def up
    remove_index :test_associations, [:test_case_id, :test_suite_id]
    add_column :test_associations, :nested_test_suite_id, :integer
    change_column :test_associations, :test_case_id, :integer, :null => true
    add_index :test_associations, [:test_suite_id, :test_case_id, :nested_test_suite_id], :unique => true, :name => :index_test_associations_cases_and_suites
  end

  def down
    remove_index :test_associations, :name => :index_test_associations_cases_and_suites
    remove_column :test_associations, :nested_test_suite_id
    change_column :test_associations, :test_case_id, :integer, :null => false
    add_index :test_associations, [:test_case_id, :test_suite_id], :unique => true
  end
end
