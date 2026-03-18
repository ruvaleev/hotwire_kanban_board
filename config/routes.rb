# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :boards do
    resources :columns, only: [] do
      resources :tasks, only: %i[new create edit update destroy] do
        member do
          patch :move
        end
      end
    end
  end

  root 'boards#index'
end
