class CreateBonusCodes < ActiveRecord::Migration
  def change
    create_table :bonus_codes, id: false do |t|
      t.references :product, null: false         # we don't need index here, as we always search by code
      t.integer :code, limit: 12, null: false    # task sample "68483737392”
    end
    add_index :bonus_codes, :code, unique: true  # bonus code is unique for "if bonus code hasn’t been sold" case
    add_foreign_key :bonus_codes, :products      # this does not work with SQLite yet
  end
end
