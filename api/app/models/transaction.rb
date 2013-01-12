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
  validates :status, :presence => true, :numericality => { :only_integer => true }, :inclusion => { :in => 0..2 }

  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  before_validation :set_status

private
  def set_status
    self.status = 0 unless status.present?
  end
  
end
