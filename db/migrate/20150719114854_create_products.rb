class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.integer :status, limit: 1, null: false, default: 0    # 0: Pre-loaded, 1: via Service
      t.integer :service, limit: 1, null: false, default: 0   # 0: No Service, 1: TV, 2: RTG
      t.timestamps null: false
    end
  end
end

