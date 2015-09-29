class AddCtypeToImages < ActiveRecord::Migration
  def change
    add_column :images, :ctype, :string
  end
end
