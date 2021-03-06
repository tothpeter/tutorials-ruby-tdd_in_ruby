require_relative "spec_helper"
require_relative "../lib/team"
require_relative "../lib/player"

describe Team do
  it "has a name" do
    Team.new("Random name").should respond_to :name
  end

  it "has a list of players" do
    Team.new("Random name").players.should be_kind_of Array
  end

  it "is favored if it has a celebrity in it" do
    # Method missing is called, cause there is no be_favored method, tries to check
    # if the subject of the spec has a method called favored? (2nd part, be_predicate)
    Team.new("Random name", [ "George Clooney", "Toma"]).should be_favored
  end

  it "complains if there is a bad word in the name" do
    expect { Team.new("Crappy name") }.to raise_error
  end

  # It is as same as describe, sugar syntax to increase readability
  context "given a bad list of players" do
    # set some variable
    let(:bad_players) { {} }

    it "fails to create given a bad player list" do
      expect { Team.new("Random name", bad_players) }.to raise_error
    end
  end

  context "having a tag" do
    let(:team) { Team.new("Random team", [], tag: "ruby") }

    it "only accepts members that match its tag" do
      VCR.use_cassette "twitter-tomaaa08" do
        rubyist = Player.new "Tomaaa", twitter: "tomaaa08"
        team.allows_player_to_join?(rubyist).should == true
      end
    end

    it "rejects members that don't match its tag" do
      VCR.use_cassette "twitter-SzntB" do
        not_rubyist = Player.new "Not rubyist", twitter: "SzntB"
        team.allows_player_to_join?(not_rubyist).should == false
      end
    end
  end
end