class CreateRoomMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :room_messages do |t|
      t.references :room_id, null: false, foreign_key: true
      t.references :user_id, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
