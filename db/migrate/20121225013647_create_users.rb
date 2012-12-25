class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :salutation
      t.string :last_name
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :daytime_phone
      t.string :email
      t.string :password
      t.boolean :registered

      t.timestamps
    end
  end
end
