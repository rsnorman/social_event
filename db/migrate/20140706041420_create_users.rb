class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :service_id
      t.string :service_type
      t.string :profile_image_url
      t.string :access_token

      t.timestamps
    end
  end
end
