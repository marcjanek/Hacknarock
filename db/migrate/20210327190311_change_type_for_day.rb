class ChangeTypeForDay < ActiveRecord::Migration[6.1]
  def change
    change_column :people, :day, :string
  end
end
