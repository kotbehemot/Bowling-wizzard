class Game < ActiveRecord::Base
  attr_accessible :session_id, :number
  attr_accessor :advanced_frame, :game_ended

  after_create :create_frames

  has_many :frames, :order => 'number ASC'

  def total
    frames.sum(&:total)
  end

  def current_ball
    current_frame.current_ball
  end

  def current_frame
    frames.find_by_number([current_frame_number, 10].min)
  end

  def previous_frame
    frames.find_by_number([current_frame_number-1, 10].min)
  end

  def previous2_frame
    frames.find_by_number([current_frame_number-2, 10].min)
  end

  def score!(pins_knocked_down_this_turn)
    current_score = pins_knocked_down_this_turn
    current_score -= current_frame.total if current_frame_number < 11

    current_frame.score!(current_score)
    previous_frame.score!(current_score) if previous_frame && previous_frame.strike? && previous_frame.number != 10
    previous_frame.score!(current_score) if previous_frame && previous_frame.spare? && (current_frame.throws_count == 1 || current_frame.strike?) && previous_frame.number != 10
    previous2_frame.score!(current_score) if previous2_frame && previous2_frame.strike? && previous_frame.strike? && previous2_frame.number != 10
    
    if advance_frame?
      self.current_frame_number += 1 
      self.advanced_frame = 1
    end
    
    if new_game?
      self.game_ended = 1
    end
    
    save!
  end

  def advance_frame?
    current_frame.total >= 10 || current_frame_number > 10 || current_frame.current_ball > 2
  end

  def new_game?
    current_frame_number > 12 || (current_frame_number == 11 && !previous_frame.strike? && !previous_frame.spare?) || (current_frame_number > 11 && !previous_frame.strike? && !previous2_frame.strike?)
  end

  protected
  def create_frames
    1.upto 10 do |i|
      frames << Frame.new(:number => i)
    end
  end

end
