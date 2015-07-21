# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Create products
Product.create([
    {id: 1, title: "Halo 4", status: 1},
    {id: 2, title: "Samsung Galaxy 4", status: 1, service: 1},
    {id: 3, title: "Skype $10", status: 1, service: 2}
])

# Pre-load bonus codes
for code in (68483737390..68483737500)
    BonusCode.create(product_id: 1, code: code)
    BonusCode.create(product_id: 2, code: code + 10005)
end
