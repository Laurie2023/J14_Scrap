require_relative '../lib/03_deputy.rb' 

describe "the database_url method" do
  it "should return 1/ an array response and 2/ the response should not be not nil" do
   expect(database_url).not_to be_nil
   expect(database_url.class).to eq(Array)
   end

  it "should return at leat a length of 570 (today, there are 577 municipalities)" do
    expect(database_url.length).to be >570
  end

  it "should return 1/ an hash response and 2/ the response should not be not nil" do
    expect(database_url[0]).not_to be_nil
    expect(database_url[0].class).to eq(Hash)
    end

  it "should return 3 like each hash on the array contains a first name, a last name and an email" do
    expect(database_url[0].length).to eq(3)
  end

end 