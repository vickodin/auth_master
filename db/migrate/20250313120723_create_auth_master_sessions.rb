class CreateAuthMasterSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :auth_master_sessions, id: :uuid do |t|
      t.references :target, polymorphic: true,  null: false, type: :uuid
      t.integer :status, limit: 2, null: false

      t.timestamps
    end
  end
end
