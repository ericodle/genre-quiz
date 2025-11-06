class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :age
      t.string :nationality
      t.date :date_of_test, null: false
      t.string :email

      t.timestamps
    end
  end
end

