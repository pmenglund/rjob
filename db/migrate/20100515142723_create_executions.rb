class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.integer :job_id, :null => false
      t.string :host, :null => false
      t.integer :result, :null => true
      t.text :stdout, :default => ""
      t.text :stderr, :default => ""
      t.integer :status, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :executions
  end
end
