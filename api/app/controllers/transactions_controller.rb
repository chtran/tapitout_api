class TransactionsController < ApplicationController

  def create
  @transaction = Transaction.new(params[:transaction])
  if @transaction.valid?
    @transaction.save

    respond_to do |format|
      format.json { render }
    end
  end

  def confirm
  end

end