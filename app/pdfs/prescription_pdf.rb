class PrescriptionPdf < Prawn::Document

  require 'prawn/table'

  def initialize(prescriptions)
    super()
    @prescriptions = prescriptions
    header
    text_content
    list_prescription_rows
  end

  def header
    text "Let do something really interesting" , size: 20, align: :center, skip_encoding: true
  end

  def text_content

  end

  def prescription_table_header
    ['SN', '#', 'Doctor', 'Hospital Unit']
   end

  def prescription_table_content
  	[prescription_table_header, *prescription_table_rows]
  end

  def prescription_table_rows
      @prescriptions.collect.with_index(1) do |prescription,index|
      [index,prescription.id, prescription.user.try(:first_name), prescription.hospital_unit.try(:hospital_unit_name)]
    end
  end

  def list_prescription_rows
  	table prescription_table_content do
  		row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40,40, 200, 200]
  	end
  end

end