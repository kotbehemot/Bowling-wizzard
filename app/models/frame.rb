class Frame < ActiveRecord::Base
  attr_accessible :number, :throw1, :throw2, :bonus

  belongs_to :game

  def strike?
    throw1 == 10
  end

  def spare?
    throw1 < 10 && throw1 + throw2 == 10
  end

  def current_ball
    throws_count + 1
  end

  def total
    throw1 + throw2 + bonus
  end

  def score!(current_score)
    case current_ball
      when 1 then self.throw1 = current_score
      when 2 then self.throw2 = current_score
      else self.bonus += current_score
    end
    self.throws_count += (strike? ? 2 : 1)
    save!
  end

end
