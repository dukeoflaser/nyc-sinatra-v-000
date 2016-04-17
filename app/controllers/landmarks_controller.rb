require_relative 'application_controller'

class LandmarksController < ApplicationController

  get '/landmarks' do
    erb :landmarks
  end

  get '/landmarks/new' do
    erb :'landmarks/new'
  end
  
  post '/landmarks/new' do
    landmark_name = params[:landmark][:name]  
    
    unless landmark_name.empty?
      new_landmark = Landmark.all.find { |l| l.name == landmark_name }
      new_landmark ||= Landmark.create(name: landmark_name)
    end
    
    redirect '/landmarks'
  end
  
  get '/landmarks/:id' do
    @landmark = Landmark.find_by_id(params[:id])
    erb :'/landmarks/show'
  end
  
  get '/landmarks/:id/edit' do
    @landmark = Landmark.find_by_id(params[:id])
    erb :'landmarks/edit'
  end
  
  post '/landmarks/:id' do
    @landmark = Landmark.find_by_id(params[:id])
    @landmark.name = params[:landmark][:name]
    @landmark.year_completed = params[:landmark][:year_completed]
    @landmark.save
    
    redirect "/landmarks/#{@landmark.id}"
  end
  
end
