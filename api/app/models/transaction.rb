class Transaction < ActiveRecord::Base
  attr_accessible :amount, :receiver_id, :sender_id, :status

  validates :amount, :presence => true, :numericality => { :only_integer => true }
  validates :receiver_id, :presence => true
  validates :sender_id, :presence => true
  validates :status, :presence => true, :numericality => { :only_integer => true }, :inclusion => { :in => 0..2 }

  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  
end