require "espnff/version"

module Espnff
  # Your code goes here...
  def self.league_schedules
    require 'rest-client'
    require 'json'
    require 'ostruct'

    # "http://games.espn.com/ffl/api/v2/leagueSchedules?leagueId=511167&seasonId=2016"
    url = "http://games.espn.com/ffl/api/v2/leagueSchedules?leagueId=511167"
    response = RestClient.get(url)
    JSON.parse(response)
  end

  def self.output_matchups
    matchups = []
    # require 'pry-byebug'
    # binding.pry
    #
    league_schedules = self.league_schedules
    weeks = league_schedules["leagueSchedule"]["scheduleItems"]
    weeks.each do |week|
      week["matchups"].each do |matchup|
        matchups << Matchup.new(matchup)
      end
    end

    p matchups.inspect
    puts matchups.length
  end

  class Matchup
    attr_accessor :away_team_score, :away_team_id, :home_team_score, :home_team_id, :result

    def initialize(json)
      hash = parse_json(json)
      self.away_team_score = hash[:away_team_score]
      self.away_team_id = hash[:away_team_id]
      self.home_team_score = hash[:home_team_score]
      self.home_team_id = hash[:home_team_id]
      self.result = hash[:result]
    end

    def parse_json(json)
      hash = {}

      hash[:away_team_score] = json["awayTeamScores"].first
      hash[:away_team_id] = json["awayTeam"]["teamId"]
      hash[:home_team_score] = json["homeTeamScores"].first
      hash[:home_team_id] = json["homeTeam"]["teamId"]
      hash[:result] = json["outcome"]

      hash
    end
  end
end
