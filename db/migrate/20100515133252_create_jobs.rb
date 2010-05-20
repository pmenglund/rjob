class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :title
      t.string :user
      t.string :script
      t.text :command
      t.text :hosts
      t.timestamps
    end
  end
  
  def self.down
    drop_table :jobs
  end
end
