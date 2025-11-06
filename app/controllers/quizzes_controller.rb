class QuizzesController < ApplicationController
  before_action :find_quiz, only: [:show, :question, :answer, :results]

  def new
    @datasets = Dataset.all
  end

  def create
    dataset = Dataset.find_by(id: params[:dataset_id])
    unless dataset
      redirect_to root_path, alert: 'Invalid dataset selected'
      return
    end

    # Create user
    user = User.create!(
      name: params[:name],
      age: params[:age].present? ? params[:age].to_i : nil,
      nationality: params[:nationality],
      date_of_test: params[:date_of_test] || Date.today,
      email: params[:email]
    )

    # Get all songs from dataset, randomized
    songs = dataset.songs.random.to_a
    
    if songs.empty?
      redirect_to root_path, alert: "No songs found in dataset"
      return
    end

    # Create quiz with all songs
    quiz = Quiz.create!(
      dataset: dataset,
      user: user,
      total_questions: songs.count
    )

    # Create questions for all songs
    songs.each_with_index do |song, index|
      quiz.questions.create!(
        song: song,
        question_number: index + 1
      )
    end

    redirect_to question_quiz_path(quiz, question_number: 1)
  end

  def show
    redirect_to question_quiz_path(@quiz, question_number: @quiz.current_question_number)
  end

  def question
    question_number = params[:question_number].to_i
    @question = @quiz.questions.find_by(question_number: question_number)
    
    unless @question
      if @quiz.completed?
        redirect_to results_quiz_path(@quiz)
      else
        redirect_to root_path, alert: 'Question not found'
      end
      return
    end

    @song = @question.song
    @genres = @quiz.dataset.genre_list
    @current_number = question_number
    @total_questions = @quiz.total_questions
    @progress = (@current_number.to_f / @total_questions * 100).round
  end

  def answer
    @question = @quiz.questions.find_by(question_number: params[:question_number].to_i)
    
    unless @question
      redirect_to root_path, alert: 'Question not found'
      return
    end

    selected_genre = params[:selected_genre]
    confidence = params[:confidence].to_i if params[:confidence].present?
    
    unless selected_genre.present?
      redirect_to question_quiz_path(@quiz, question_number: @question.question_number),
                  alert: 'Please select a genre'
      return
    end

    # Answer the question
    @question.answer_question!(selected_genre, confidence: confidence)

    # Move to next question or complete quiz
    next_question_number = @question.question_number + 1
    
    if next_question_number > @quiz.total_questions
      @quiz.complete!
      redirect_to results_quiz_path(@quiz)
    else
      redirect_to question_quiz_path(@quiz, question_number: next_question_number)
    end
  end

  def results
    unless @quiz.completed?
      redirect_to question_quiz_path(@quiz, question_number: @quiz.current_question_number)
      return
    end

    @total_correct = @quiz.total_correct
    @total_questions = @quiz.total_questions
    @accuracy = @quiz.accuracy
    @results_by_genre = @quiz.results_by_genre
    @questions = @quiz.questions.includes(:song, :answer).ordered
  end

  private

  def find_quiz
    @quiz = Quiz.find_by(id: params[:id] || params[:quiz_id])
    unless @quiz
      redirect_to root_path, alert: 'Quiz not found'
    end
  end
end

