class CreateGreetings < ActiveRecord::Migration[6.1]
  def change
    create_table :greetings do |t|
      t.string :phrase,   limit: 50, null: false
      t.string :subtitle, limit: 255

      t.timestamps
    end
  end
end
