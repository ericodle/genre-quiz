Rails.application.routes.draw do
  root 'quizzes#new'
  
  resources :quizzes, only: [:new, :create, :show], param: :id do
    member do
      get 'question/:question_number', to: 'quizzes#question', as: 'question'
      post 'question/:question_number/answer', to: 'quizzes#answer', as: 'answer'
      get :results
    end
  end
  
  get '/audio/:dataset/:genre/:filename', to: 'audio#serve', constraints: { filename: /.*/ }, as: 'audio_serve'
end

