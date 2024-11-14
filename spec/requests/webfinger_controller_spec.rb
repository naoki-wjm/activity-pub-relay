require "rails_helper"

RSpec.describe "/.well-known/webfinger", type: :request do
  describe "GET /.well-known/webfinger" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LOCAL_DOMAIN", "www.example.com").and_return("www.example.com")

      get "/.well-known/webfinger"
    end

    it "should return json" do
      expect(response.content_type).to eq 'application/activity+json; charset=utf-8'
    end

    it "should return 200" do
      expect(response.status).to eq 200
    end

    it "has actor data" do
      expected_json = {
        "subject" => "acct:relay@www.example.com",
        "links" => [
          {
            "rel" =>  "self",
            "type" => "application/activity+json",
            "href" => "https://www.example.com/actor"
          }
        ]
      }

      actuacl_json = JSON.parse(response.body)

      expect(expected_json).to eq actuacl_json
    end
  end
end