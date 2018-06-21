require 'json'
require 'byebug'

RSpec.describe "Neoway::Request", type: :request do

  context "authentication", :vcr do
    it "raises error if configs not set" do
      Neoway.user_name = ""
      Neoway.password = ""

      expect {Neoway::Request.get_token}.to raise_error(NoApiKey)
    end

    it ".get_token" do
      Neoway.user_name = "test"
      Neoway.password = "test-password"

      response = Neoway::Request.get_token

      expect(response).not_to be nil
    end


    it ".valid_token?" do
      Neoway.user_name = "test"
      Neoway.password = "test-password"

      valid = Neoway::Request.valid_token?

      expect(valid).to be true
    end
  end
end
