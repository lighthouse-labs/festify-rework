# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'dotenv'
require 'json'
require 'rest-client'
Dotenv.load

def seedEvents 
  api_key = ENV["EDMTRAIN_API_KEY"]

  url = "https://edmtrain.com/api/events?events?startDate=2022-07-&endDate=2022-08-25&livestreamInd=false&locationIds=5&festivalInd=true&client=#{api_key}"

  @response = RestClient::Request.execute(method: :get, url: url, verify_ssl: false)

  @events_info = JSON.parse(@response.body)

  @events_info["data"].map do |event|
    Event.create(edmtrain_event_id: event["id"], name: event["name"], date: event["date"], location: event["venue"]["location"])
    event["artistList"].map do |artist|
      Gig.create(event_id: event["id"], artist_id: artist["id"])
      # if artist["id"] is not in Artist table 
        # Artist.create(id: artist["id"], name: artist['name'])
    end
  end
end

seedEvents()