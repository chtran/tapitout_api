require 'spec_helper'

describe "Transactions" do

  before do
    @sender = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user)
  end

  describe "create" do

    before do
      @url = "/transactions"
      @params = {
        :sender_id => @sender.id,
        :receiver_id => @receiver.id,
        :amount => 1000
        # AUTH TOKEN
      }
    end

    it "should create a transaction for the sender" do
      expect { post @url, @params }.to change(@sender.sent_transactions.count).by(1)
    end
    
    it "should create a transaction for the receiver" do
      expect { post @url, @params }.to change(@receiver.received_transactions.count).by(1)
    end

  end

  describe "confirm" do
    before do
      @transaction = @sender.sent_payments.create(amount: 1000, receiver_id: @receiver.id)
      @url = "/transactions/#{@transaction.id}/confirm"

      @params = {
        status: 1
      }
    end

    it "should confirm the transaction" do
      post @url, @params
      Transaction.find_by_id(@transaction.id).status.should == 1
    end

    it "should cancel the transaction" do
      before do
        @params = {
          status: 2
        }
      end

      post @url, @params
      Transaction.find_by_id(@transaction.id).status.should == 2
    end

    it "should not allow an invalid status" do
      before do
        @params = {
          status: 24
        }
      end

      post @url, @params
      Transaction.find_by_id(@transaction.id).status.should == 0
    end
  end

end