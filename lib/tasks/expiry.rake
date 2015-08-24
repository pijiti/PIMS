task :expiry => :environment do
  InventoryBatch.expiry_date_check
  puts "completed expiry check======>"
end