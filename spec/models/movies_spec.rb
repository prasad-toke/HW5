require 'rails_helper'

  describe Movie do
    describe 'search the TMDB via search string' do
      it 'should connect the TMDB api with search string given we have a valid api key' do
        Tmdb::Movie.should_receive(:find)
        Movie.find_in_tmdb('Amelie')
      end
    end

    describe 'add a movie' do
      it 'should connect the TMDB api to get movie details' do
       # Tmdb::Movie.should_receive(:detail)
        Movie.create_from_tmdb(250845)
      end
    end

  end
