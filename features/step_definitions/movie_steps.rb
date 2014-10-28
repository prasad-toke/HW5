# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!( :title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
  end
  #flunk "Unimplemented"
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  uncheck('ratings_G')
  uncheck('ratings_R')
  uncheck('ratings_PG')
  uncheck('ratings_PG-13')
  arg= arg1.split(/[\s,]+/)
  arg.each do |a|
    a = 'ratings_' + a
    page.check(a)
  end

  
  click_button('ratings_submit')
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  #flunk "Unimplemented"
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
    n = 0
    arg= arg1.split(/[\s,]+/)
    arg.each do |a|
      a = "<td>" + a + "</td>"
      n += page.body.scan(a).length
    end 

    total_rows = page.body.scan(/<tr>/).length
    
    total_rows.should == n + 1
	
end

Then /^I should see all of the movies$/ do
  rows = Movie.find(:all).length + 1 # +1 for the header

   rows.should == page.body.scan(/<tr>/).length
end

When /^I have clicked on link "(.*?)"$/ do |link_name|
  click_link(link_name)
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |m1, m2|
    puts m1 + " ******* " + m2

    i1 = page.body.index(m1)
    i2 = page.body.index(m2)
    if ( i1 < i2)
	assert true    
    else
        assert false
    end

end

