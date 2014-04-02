class Transfer < ActiveRecord::Base
  belongs_to :account

  def deposit?
    direction == 'deposit'
  end

  def withdrawal?
    direction == 'withdrawal'
  end
end
