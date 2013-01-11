class User < ActiveRecord::Base
  attr_accessible :balance, :email, :name, :password
  validates_presence_of :password, :email, :name, :balance
  validates :password, :length => {:minimum => 6}
  validates :email, :uniqueness => true, :format => {:with => /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/}
  validates :balance, :numericality => {:only_integer => true}

  has_many :sent_transactions, class_name: "Transaction", foreign_key: "sender_id"
  has_many :received_transactions, class_name: "Transaction", foreign_key: "receiver_id"
end
