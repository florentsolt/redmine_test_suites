class TestBase < ActiveRecord::Migration
  def up
    create_table :test_suites do |t|
      t.string :title, :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end

    create_table :test_cases do |t|
      t.string :title, :null => false
      t.text :description
      t.text :steps
      t.belongs_to :user, :null => false
      t.timestamps
    end

    create_table :test_associations do |t|
      t.belongs_to :test_case, :null => false
      t.belongs_to :test_suite, :null => false
      t.integer :order, :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end

    add_index :test_associations, [:test_case_id, :test_suite_id], :unique => true

    create_table :test_issues do |t|
      t.belongs_to :test_case, :null => false
      t.belongs_to :issue, :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end

    add_index :test_issues, [:test_case_id, :issue_id], :unique => true

    create_table :test_executions do |t|
      t.belongs_to :test_suite, :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end

    create_table :test_logs do |t|
      t.integer :status, :null => false
      t.text :comment
      t.belongs_to :test_case, :null => false
      t.belongs_to :test_execution
      t.belongs_to :user, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :test_suites
    drop_table :test_cases
    drop_table :test_associations
    drop_table :test_issues
    drop_table :test_logs
    drop_table :test_executions
  end
end
