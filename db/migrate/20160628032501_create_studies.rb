class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.decimal :height
      t.decimal :weight
      t.string :likes

      t.timestamps null: false
    end
  end
end
