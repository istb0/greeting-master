class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results, id: false do |t|
      t.string  :id, limit: 36, null: false, primary_key: true
      t.integer :score,  null: false
      t.integer :calm,   null: false
      t.integer :anger,  null: false
      t.integer :joy,    null: false
      t.integer :sorrow, null: false
      t.integer :energy, null: false
      t.references :greeting, foreign_key: true, null: false

      t.timestamps
    end
  end
end
