class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end

  def self.find_in_tmdb params
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    movies = Tmdb::Movie.find(params)
    temp_arr = Array.new

    if movies.blank?
      return []
    else
      movies.each do |m|
        temp_hash = Hash.new
        temp_hash[:title] = m.title
        temp_hash[:rating] = "R"
        temp_hash[:release_date] = m.release_date
        temp_hash[:id] = m.id
        temp_arr.push(temp_hash)
      end
    end
    return temp_arr

  end

  def self.create_from_tmdb param
    obj = Tmdb::Movie.detail(param)
    m_hash = Hash.new
    m_hash[:title] = obj.title
    m_hash[:rating] = "R"
    m_hash[:release_date] = obj.release_date
    Movie.create!(m_hash)
  end
end
