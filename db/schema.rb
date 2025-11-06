# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "selected_genre", null: false
    t.boolean "is_correct", null: false
    t.integer "confidence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id", unique: true
  end

  create_table "datasets", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "base_path", null: false
    t.integer "total_songs", default: 0
    t.jsonb "genres", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_datasets_on_name", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.bigint "song_id", null: false
    t.integer "question_number", null: false
    t.datetime "presented_at"
    t.datetime "answered_at"
    t.float "time_spent_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id", "question_number"], name: "index_questions_on_quiz_id_and_question_number"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
    t.index ["song_id"], name: "index_questions_on_song_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "session_id", null: false
    t.bigint "dataset_id", null: false
    t.string "status", default: "in_progress"
    t.integer "total_questions", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["dataset_id"], name: "index_quizzes_on_dataset_id"
    t.index ["session_id"], name: "index_quizzes_on_session_id", unique: true
    t.index ["status"], name: "index_quizzes_on_status"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.bigint "dataset_id", null: false
    t.string "genre", null: false
    t.string "filename", null: false
    t.string "relative_path", null: false
    t.string "full_path", null: false
    t.integer "file_size"
    t.float "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dataset_id", "genre"], name: "index_songs_on_dataset_id_and_genre"
    t.index ["dataset_id"], name: "index_songs_on_dataset_id"
    t.index ["full_path"], name: "index_songs_on_full_path", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "age"
    t.string "nationality"
    t.date "date_of_test", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "questions", "songs"
  add_foreign_key "quizzes", "datasets"
  add_foreign_key "quizzes", "users"
  add_foreign_key "songs", "datasets"
end
