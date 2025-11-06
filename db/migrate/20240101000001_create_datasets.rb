class CreateDatasets < ActiveRecord::Migration[7.1]
  def change
    create_table :datasets do |t|
      t.string :name, null: false
      t.text :description
      t.string :base_path, null: false
      t.integer :total_songs, default: 0
      t.jsonb :genres, default: []

      t.timestamps
    end

    add_index :datasets, :name, unique: true
  end
end

