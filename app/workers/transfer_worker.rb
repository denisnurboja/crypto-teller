class TransferWorker
  include Sidekiq::Worker

  def perform(transfer_id)
    transfer = Transfer.find(transfer_id)
    account = transfer.account

    if transfer.status == 'pending'
      prepare(transfer, account)
    elsif transfer.status == 'accepted'
      finalize(transfer, account)
    end
  end

  private

  def prepare(transfer, account)
    if transfer.withdrawal?
      if account.balance >= transfer.amount
        account.hold(transfer.amount)
        account.save!
      else
        transfer.update_attributes!(status: 'rejected', note: 'Insufficient balance in account')
        return
      end
    end

    transfer.update_attributes!(status: 'needs_review', note: 'Needs review from teller')
  end

  def finalize(transfer, account)
    if transfer.withdrawal?
      account.held_balance -= transfer.amount
    else
      account.balance += transfer.amount
    end

    account.save!
    transfer.update_attributes!(status: 'completed', note: 'Transfer completed')
  end

end
