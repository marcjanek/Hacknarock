class CreatePeopleInterestsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :people, :interests
  end
end
