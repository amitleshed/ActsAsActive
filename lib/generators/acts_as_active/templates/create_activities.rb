class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string  :trackable_type, null: false
      t.bigint  :trackable_id,   null: false
      t.date    :occurred_on,    null: false
      t.integer :count,          null: false, default: 0

      t.timestamps
    end

    add_index :activities, [:trackable_type, :trackable_id, :occurred_on], unique: true, name: "index_activities_on_trackable_and_occurred_on"
  end
end
