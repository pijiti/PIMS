json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :batch_id, :inventory_id, :from_store_id, :qty, :confirm_receipt, :received_qty
  json.url receipt_url(receipt, format: :json)
end
