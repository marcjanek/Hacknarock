class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :name
      t.numeric :age
      t.boolean :gender
      t.text :description
      t.numeric :day
      t.numeric :hour
      t.numeric :group_size
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
