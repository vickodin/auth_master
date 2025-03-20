class CreateManagers < ActiveRecord::Migration[8.0]
  def change
    create_table :managers, id: :uuid do |t|
      t.string :email, null: false
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :managers, [:email, :company_id], unique: true
  end
end
