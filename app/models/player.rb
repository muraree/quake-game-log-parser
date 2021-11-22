# frozen_string_literal: true

# app/models/player.rb
class Player
  attr_accessor :name, :kill_times, :no_suicide_death_times, :suicide_times

  def initialize(name, kill_times = 0, no_suicide_death_times = 0, suicide_times = 0)
    @name = name
    @kill_times = kill_times
    @no_suicide_death_times = no_suicide_death_times
    @suicide_times = suicide_times
  end

  def kill(player)
    if self == player || @name == '<world>'
      player.suicide_times += 1
    else
      @kill_times += 1
      player.no_suicide_death_times += 1
    end
  end

  def get_score
    @kill_times - @suicide_times
  end

  def ==(other)
    other.name == @name
  end
end
