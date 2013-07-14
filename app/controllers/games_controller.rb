class GamesController < ApplicationController
  def index
    if params[:room_id].blank?
      redirect_to :room_id => SecureRandom.hex(16)
      return
    end
    @games = Game.where(:session_id => params[:room_id]).order(:number)
    if @games.blank?
      @game = Game.create(:number => 1, :session_id => params[:room_id])
    end
    if @games.last.new_game?
      @game = Game.create(:number => @games.last.number + 1, :session_id => params[:room_id])
    end
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

  def destroy

  end
end
