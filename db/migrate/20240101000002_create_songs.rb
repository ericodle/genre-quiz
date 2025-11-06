class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.references :dataset, null: false, foreign_key: true
      t.string :genre, null: false
      t.string :filename, null: false
      t.string :relative_path, null: false
      t.string :full_path, null: false
      t.integer :file_size
      t.float :duration

      t.timestamps
    end

    add_index :songs, [:dataset_id, :genre]
    add_index :songs, :full_path, unique: true
  end
end

