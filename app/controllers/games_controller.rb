class GamesController < ApplicationController
  def index 
    redirect_to :room_id => SecureRandom.hex(16) and return if params[:room_id].blank?
    @games = Game.where(:session_id => params[:room_id]).order(:number)
    @game = Game.create(:number => 1, :session_id => params[:room_id]) if @games.blank?
    @game = Game.create(:number => @games.last.number + 1, :session_id => params[:room_id]) if @games.last.new_game?
  end

  def create
    @games = Game.where(:session_id => params[:room_id])
    @game = Game.create(:session_id => params[:room_id], :number => @games.count + 1)
    render @game
  end

  def update
    @game = Game.find(params[:id])
    @game.score! params[:score].to_i
    render @game
  end
end
