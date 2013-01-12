class TransactionsController < ApplicationController
  def create
  @transaction = current_user.sent_transactions.new(params[:transaction])
    if @transaction.valid?
      @transaction.save

      respond_to do |format|
        format.json { render }
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
      @transaction.status = params[:transaction][:status]
      if @transaction.valid?
        @transaction.save
        respond_to do |format|
          format.json { render }
        end
      else
        respond_to do |format|
          format.json { render json: { error: "Invalid transaction status" } }
        end
      end
    end
  end

end