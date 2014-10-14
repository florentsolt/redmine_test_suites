class CaseConditions < ActiveRecord::Migration
  def up
    add_column :test_cases, :preconditions, :text
    add_column :test_cases, :postconditions, :text
  end

  def down
    remove_column :test_cases, :preconditions
    remove_column :test_cases, :postconditions
  end
end
