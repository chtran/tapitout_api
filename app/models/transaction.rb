# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  receiver_id :integer
#  sender_id   :integer
#  amount      :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Transaction < ActiveRecord::Base
	
  attr_accessible :amount, :receiver_id

  validates :amount, :presence => true, :numericality => { :only_integer => true }
  # validates :receiver_id, :presence => true
  validates :sender_id, :presence => true
  validates :status, :presence => true, :numericality => { :only_integer => true }, :inclusion => { :in => 0..3 }

  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  before_validation :set_status

  def process?(old_status)
    old_status != 1 && has_enough? && status == 1
  end

  def has_enough?
    sender.balance > amount
  end

  def sender_name
    if sender.nil?
      ""
    else
      sender.name
    end
  end

  def receiver_name
    if receiver.nil?
      ""
    else
      receiver.name
    end
  end

private
  def set_status
    self.status = 0 unless status.present?
  end
end