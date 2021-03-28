class DeleteGenderFromPerson < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :gender
  end
end
