class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :number
      t.string :usage , default: "ORDER"

      t.timestamps
    end
  end
end
