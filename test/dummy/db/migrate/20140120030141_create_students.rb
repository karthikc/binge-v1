class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.date :date_of_birth
      t.integer :school_id

      t.timestamps
    end
  end
end
