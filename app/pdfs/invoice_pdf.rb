class InvoicePdf < Prawn::Document

  def initialize(resources)
    super()
    text "Let do something really interesting" , size: 20, align: :center, skip_encoding: true
    draw_text "Receipt", :at => [220, 575], size: 22
  end


end