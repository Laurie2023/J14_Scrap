require_relative '../lib/01_crypto_scrap.rb' 

describe "the database method" do
  it "should return an array response, and response is not nil" do
   expect(database).not_to be_nil
   expect(database.class).to eq(Array)
   end

  it "should return at leat a length of 100 (there are 200 lines on the front page)" do
    expect(database.length).to be >100
  end

  it "should return not nil to check 1/if there is BTC in the list && 2/if BTC value is not nil" do
    btc_value = database.find { |h| h.key?("BTC") }["BTC"]
    expect(btc_value).not_to be_nil
  end
 
end