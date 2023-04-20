require_relative '../lib/02_marie_christmas.rb' 

describe "the database_url method" do
  it "should return 1/ an array response and 2/ the response should not be not nil" do
   expect(database_url).not_to be_nil
   expect(database_url.class).to eq(Array)
   end

  it "should return at leat a length of 150 (today, there are 180 municipalities)" do
    expect(database_url.length).to be >150
  end

  it "should return true if the first url of the array contains the base of the directory website's url" do
    expect(database_url[0].include?"http://www.annuaire-des-mairies.com").to eq(true)
  end
 
end

describe "the name_email_municipalities method" do
  it "should return an array response, and response is not nil" do
   expect(name_email_municipalities(database_url)).not_to be_nil
   expect(name_email_municipalities(database_url).class).to eq(Array)
   end

  it "should return at leat a length of 150 (today, there are 180 municipalities)" do
    expect(name_email_municipalities(database_url).length).to be >150
  end

  it "should return not nil to check 1/if there is FONTENAY-EN-PARISIS in the list && 2/if FONTENAY-EN-PARISIS value is not nil" do
    btc_value = name_email_municipalities(database_url).find { |h| h.key?("FONTENAY-EN-PARISIS") }["FONTENAY-EN-PARISIS"]
    expect(btc_value).not_to be_nil
  end
 
end