class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @transaction = current_user.sent_transactions.find_by_id(params[:id]) || current_user.received_transactions.find_by_id(params[:id])
    if @transaction.nil?
      respond_to do |format|
        format.json { render json: { error: "Invalid transaction id" } }
      end
    else
      respond_to do |format|
        format.json { render "transaction" }
      end
    end
  end

  def create
    @transaction = current_user.sent_transactions.new(params[:transaction])
    if @transaction.valid?
      @transaction.save

      respond_to do |format|
        format.json { render "transaction" }
      end
    end
  end

  def confirm
    @transaction = current_user.sent_transactions.find_by_id(params[:id])
    if @transaction.nil?
      respond_to do |format|
        format.json { render json: { error: "Invalid transaction id" } }
      end
    else
      old_status = @transaction.status
      @transaction.status = params[:transaction][:status]
      if @transaction.valid?
        @transaction.save

        if @transaction.process?(old_status)
          @transaction.receiver.balance += @transaction.amount
          @transaction.receiver.save
          current_user.balance -= @transaction.amount
          current_user.save
        end

        respond_to do |format|
          format.json { render "transaction" }
        end
      else
        respond_to do |format|
          format.json { render json: { error: "Invalid transaction status" } }
        end
      end
    end
  end

  def receive
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.receiver_id = current_user.id
    if @transaction.save
      respond_to do |format|
        format.json { render "transaction" }
      end
    end
  end
end