class Transaction < ActiveRecord::Base
  attr_accessible :amount, :receiver_id, :sender_id, :status
end
