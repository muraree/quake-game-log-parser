# frozen_string_literal: true

# app/controllers/home_controller.rb
class HomeController < ApplicationController
  include LogUtils

  def index
    @results = QuakeLogParser.new(log_file_path).parse_log_file
  end
end
