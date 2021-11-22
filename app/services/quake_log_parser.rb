# frozen_string_literal: true

require_relative 'log_utils'

# app/services/quake_log_parser.rb
class QuakeLogParser
  include LogUtils

  attr_reader :games

  def initialize(log_file = log_file_path)
    @log_file = log_file
    @games = []
    @current_game = nil
  end

  def parse_log_file
    read_from_file(@log_file) do |file|
      file.each do |line|
        parse_line_data(line)
      end
    end
    @games
  end

  def parse_line_data(line)
    if game_start?(line)
      initialize_game
    elsif player_line?(line)
      handle_player_addition(line)
    elsif kill_event?(line)
      handle_kill_events(line)
    elsif game_over?(line)
      @games << @current_game if @current_game && !@games.include?(@current_game)
    end
  end

  def initialize_game
    game_name = "game_#{@games.length + 1}"
    @current_game = Game.new(game_name)
  end

  def handle_player_addition(line)
    player_name = get_player_name(line)
    @current_game.add_player(player_name)
  end

  def handle_kill_events(line)
    killer, killed, kill_reason = get_kill_info_from_kill_event(line)
    kill_reason = kill_reason.to_sym
    kill_reason = :MOD_UNKNOWN unless MEANS_OF_DEATH.include?(kill_reason)
    @current_game.deal_with_kill_event(killer, killed, kill_reason)
  end
end
