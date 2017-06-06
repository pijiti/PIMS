if Rails.env == "production"
$pdf_files_location = "/home/admin/Documents/orders"
else
  $pdf_files_location = "/tmp"
end

