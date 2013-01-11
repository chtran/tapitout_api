class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.integer :amount
      t.integer :status

      t.timestamps
    end
  end
end
