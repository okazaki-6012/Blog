class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.binary :file

      t.timestamps
    end
  end
end
