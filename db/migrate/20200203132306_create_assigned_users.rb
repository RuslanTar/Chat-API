class CreateAssignedUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :assigned_users do |t|
      t.belongs_to :room, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
