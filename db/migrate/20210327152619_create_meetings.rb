class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.string :uuid
      t.datetime :date

      t.timestamps
    end
  end
end
