require_relative 'application_controller'

class FiguresController < ApplicationController

  get '/figures' do
    erb :figures
  end
  
  get '/figures/new' do
    erb :'figures/new'
  end
  
  post '/figures/new' do
    figure_name = params[:figure][:name]
    landmark_name = params[:landmark][:name] 
    title_name = params[:title][:name]
    @title_ids = params[:figure][:title_ids]
    @landmark_ids = params[:figure][:landmark_ids]
    
    unless figure_name.empty?
      new_figure = Figure.all.find { |f| f.name == figure_name }
      new_figure ||= Figure.create(name: figure_name)
    else
      redirect 'figures/new'
    end
    
    unless landmark_name.empty?
      new_landmark = Landmark.all.find { |l| l.name == landmark_name }
      new_landmark ||= Landmark.create(name: landmark_name)
      new_figure.landmarks << new_landmark
    end
    
    unless title_name.empty?
      new_title = Title.all.find { |t| t.name == title_name }
      new_title ||= Title.create(name: title_name)
      new_figure.titles << new_title
    end
    
    unless @title_ids.nil?
      @title_ids.each do |id|
        new_figure.titles << Title.find_by_id(id.to_i)
      end
    end
    
    unless @landmark_ids.nil?
      @landmark_ids.each do |id|
        new_figure.landmarks << Landmark.find_by_id(id.to_i)
      end
    end
    
    new_figure.landmarks.uniq!
    new_figure.titles.uniq!
    
    redirect "/figures"
  end  

  get '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    erb :'/figures/single'
  end
   
  get '/figures/:id/edit' do
    @figure = Figure.find_by_id(params[:id]) 
    erb :'/figures/edit'
  end
   
  post '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    figure_name = params[:figure][:name]
    landmark_name = params[:landmark][:name] 
    title_name = params[:title][:name]

    unless figure_name.empty?
      @figure.name = figure_name
    end
    
    unless landmark_name.empty?
      new_landmark = Landmark.all.find { |l| l.name == landmark_name }
      new_landmark ||= Landmark.create(name: landmark_name)
      @figure.landmarks << new_landmark
    end
    
    unless title_name.empty?
      new_title = Title.all.find { |t| t.name == title_name }
      new_title ||= Title.create(name: title_name)
      @figure.titles << new_title
    end
    
    @figure.landmarks.uniq!
    @figure.titles.uniq!
    
    @figure.save
    erb :'/figures/single' 
  end
end
