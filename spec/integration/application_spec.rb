require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_albums_table
    seed_sql = File.read("spec/seeds/albums_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(seed_sql)
  end

  before(:each) { reset_albums_table }

  def reset_artists_table
    seed_sql = File.read("spec/seeds/artists_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(seed_sql)
  end

  before(:each) { reset_artists_table }

  # context "GET /albums" do
  #   it "returns a list of album titles" do
  #     response = get("/albums")
  #     expected_response =
  #       "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
  #     expect(response.status).to eq 200
  #     expect(response.body).to eq expected_response
  #   end
  # end

  context "POST /albums" do
    it "creates a new album" do
      response =
        post("/albums", title: "Voyage", release_year: "2022", artist_id: "2")
      expect(response.status).to eq 200
      expect(response.body).to eq("")
      response_2 = get("/albums")
      expect(response_2.body).to include "Voyage"
    end
  end

  context "GET /artists" do
    it "returns a list of artist names" do
      response = get("/artists")
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      expect(response.body).to eq expected_response
    end
  end

  context "POST /artists" do
    it "creates a new artist" do
      response = post("/artists", name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq 200
      expect(response.body).to eq("")
      response_2 = get("/artists")
      expect(response_2.body).to include "Wild Nothing"
    end
  end

  context "GET /albums" do
    it "returns single album in html" do
      response = get("/albums/1") 
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
    end
  end

  context "GET /albums" do
    it "returns a list of album titles" do
      response = get("/albums")
      expect(response.status).to eq 200
      expect(response.body).to include '<div><br>Title: Doolittle<br>Release year: 1989<br></div>'
      expect(response.body).to include '<div><br>Title: Ring Ring<br>Release year: 1973<br></div>'

    end
  end
end


