class AddLengthToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :length, :numeric
  end
end
