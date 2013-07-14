class FramesPresenter < ApplicationPresenter
  attr_accessor :frame
  delegate :number, :to => :frame

  def initialize(frame, context)
    super context
    @frame = frame
  end

  def throw1
    if @frame.throws_count < 1
      '&nbsp;'.html_safe
    elsif @frame.throw1 == 0
      '-'
    elsif @frame.throw1 == 10
      'X'
    else
      @frame.throw1
    end   
  end

  def throw2
    if @frame.throws_count < 2
      '&nbsp;'.html_safe
    elsif @frame.throw2 == 0
      '-'
    elsif @frame.throw1 + @frame.throw2 == 10
      '/'
    else
      @frame.throw2
    end   
  end

  def throw3
    if @frame.throws_count < 3 || @frame.number != 10
      '&nbsp;'.html_safe
    else
      @frame.bonus
    end
  end

  def total
    if @frame.throws_count < 1
      '&nbsp;'.html_safe
    else
      @frame.total
    end
  end

end 