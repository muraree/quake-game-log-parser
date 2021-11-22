# frozen_string_literal: true

require 'json'

# app/models/game.rb
class Game
  attr_reader :game_name, :players, :kills

  def initialize(game_name)
    @game_name = game_name
    @players = []
    @kills = []
  end

  def add_player(player_name)
    get_player_by_name(player_name) || create_new_player(player_name)
  end

  def deal_with_kill_event(killer, killed, kill_reason)
    killer_player = add_player(killer)
    killed_player = add_player(killed)

    killer_player.kill(killed_player)

    @kills << Kill.new(killer_player, killed_player, kill_reason)
  end

  def get_player_by_name(name)
    @players.detect { |player| player.name.eql?(name) }
  end

  def output_game_hash
    score_info = {}
    real_players.each do |player|
      score_info[player.name] = player.get_score
    end

    { @game_name => { total_kills: total_kills,
                      players: player_names,
                      kills: score_info,
                      kills_by_means: kill_reasons } }
  end

  def to_s
    JSON.pretty_generate(output_game_hash)
  end

  private

  def kill_reasons
    kill_reasons = {}
    @kills.each do |kill|
      kill_reasons[kill.kill_reason] ||= 0
      kill_reasons[kill.kill_reason] += 1
    end
    kill_reasons
  end

  def player_names
    real_players.map(&:name)
  end

  def total_kills
    @kills.length
  end

  def real_players
    @players.reject { |player| player.name == '<world>' }
  end

  def create_new_player(name)
    player = Player.new(name)
    @players << player
    player
  end
end
