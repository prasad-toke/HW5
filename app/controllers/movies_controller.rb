class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def search_tmdb
	# write all logic here
    @search_text = params[:search_text][:title]
    #flash[:notice] = "***" + search_text + "***"	
    if @search_text.blank?
    #if params[:search_text][:title].blank?
      flash[:notice] = "*** Invalid Search Term"
      redirect_to movies_path	
    else
	# other logic, search text comes in, use Tmdb::Movie.find to find all such movies, iterate through all objects ...
	# keep on creating hases with just the required fiels - tmdb id, title, rating(some fixed value) and release date ...
	# assign these to an instance variable so that you can use it show everything in respected view ...
      search_text = params[:search_text][:title]
      @movies = Movie.find_in_tmdb(search_text)

    end
   
  end

  def add_tmdb
    if params[:tmdb_movies].blank?
      flash[:notice] = "No Movie was selected"
      
    else
      params[:tmdb_movies].keys.each do |id|
        @movies = Movie.create_from_tmdb(id)
        flash[:notice] = "Movies successfully added to Rotten Potatoes"
      end
      
    end
    
    redirect_to movies_path

  end
end
