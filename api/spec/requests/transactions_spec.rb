require 'spec_helper'

describe Transaction do

  before do
    @sender = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user)
  end

  describe "create" do

    before do
      @url = "/transactions"
      @params = {
        :transaction => {
          # :sender_id => @sender.id,
          :receiver_id => @receiver.id,
          :amount => 1000,
        },
        :email => @sender.email,
        :auth_token => @sender.authentication_token
      }
    end

    it "should create a transaction for the sender" do
      # expect { post @url, @params }.to change(@sender.sent_transactions, :count)
      post @url, @params
    end
    
    it "should create a transaction for the receiver" do
      expect { post @url, @params }.to change(@receiver.received_transactions, :count)
    end

  end

  describe "confirm" do
    before do
      @transaction = @sender.sent_transactions.create(amount: 1000, receiver_id: @receiver.id)
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
      @params[:status] = 2

      post @url, @params
      Transaction.find_by_id(@transaction.id).status.should == 2
    end

    it "should not allow an invalid status" do
      @params[:status] = 24

      post @url, @params
      Transaction.find_by_id(@transaction.id).status.should == 0
    end
  end

end