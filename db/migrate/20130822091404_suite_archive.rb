class SuiteArchive < ActiveRecord::Migration
  def up
    add_column :test_suites, :archived, :boolean, :default => false
    add_column :test_suites, :executable, :boolean, :default => false
  end

  def down
    remove_column :test_suites, :archived
    remove_column :test_suites, :executable
  end
end
