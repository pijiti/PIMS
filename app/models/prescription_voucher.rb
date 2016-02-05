require 'prawn'
require 'prawn/table'
require "prawn/measurement_extensions"
include ActionView::Helpers::NumberHelper

class PrescriptionVoucher

  def initialize(prescription , dispense_store , d_user)
    @document = Prawn::Document.new(:page_size => [72.mm, 297.mm], :page_layout => :portrait,
                                    :left_margin => 1.mm,
                                    :right_margin => 1.mm,
                                    :top_margin => 3.mm,
                                    :bottom_margin => 2.mm
    )
    @prescription = prescription
    @dispense_store = dispense_store
    @dispensing_user = d_user
  end

  def generate
    @document.text "State Specialist Hospital,Ondo", :size => 14, :styles => :bold, :align => :center
    @document.text "Pharmacy Department", :size => 12, :styles => :bold, :align => :center
    @document.text "Invoice", :size => 10, :align => :center
    @document.draw_text "#{@prescription.patient.try(:firstname)} #{@prescription.patient.try(:surname)}  ", :at => [1.5.mm, 274.mm], :size => 7.5
    @document.draw_text "#{@prescription.code}", :at => [50.mm, 274.mm], :size => 7.5
    @document.draw_text "#{Time.now.strftime("%d/%m/%Y")}", :at => [1.5.mm, 271.mm], :size => 7.5
    @document.draw_text "#{Time.now.strftime("%I:%M %p")}", :at => [50.mm, 271.mm], :size => 7.5
    @document.move_down 15.mm


    @document.table( get_table_data, {cell_style: { size: 7.5, valign: :center, :align => :right, :border_width => 0}}) do |table|
      #table.header=(["Item", "Qty", "Rate", "Subtotal"])
       table.column(0).style do |c|
         c.align = :left
       end
       table.column(1).style do |c|
         c.align = :left
       end
      table.row(0)
    end

    @document.move_down 15.mm

    @document.text "Dispensary: #{@dispense_store.try(:name)}", :size => 7.5
    @document.text "Served by: #{@dispensing_user.try(:first_name)}  #{@dispensing_user.try(:last_name)}", :size => 7.5
    @document.move_down 3.mm
    #the next line is only for free medical dispensary store
    if !@dispense_store.store_operation.try(:payment_required)
       @document.text "Free Medical Service provided by ODSG to reduce maternal and child mortality", :size => 7 #,:align => :justified
    end

    @document.move_down 5.mm
    @document.text "Don’t abuse drugs,consult a Pharmacist!", :size => 9, :styles => [:bold, :italic], :align => :center
    @document.move_down 5.mm

    @document.render
  end


  def get_table_data
    formatted_table = []
    formatted_table.push [
                             'S/N',
                             'Item',
                             'Qty',
                             'Rate(N)',
                             'Amount(N)',
                         ]
    counter = 0
    total=0

    @prescription.prescription_batches.includes(:brand).order("brands.name ASC").each do |p|
      counter += 1
      total += ("%.2f" % ((p.qty.to_i) * ("%.2f" % p.rate).to_f)).to_f
      sub = "%.2f" % ((p.qty.to_i) * ("%.2f" % p.rate).to_f)
      formatted_table.push [
                               counter,
                               p.brand.try(:name),
                               p.try(:qty),
                               number_with_delimiter("#{p.try(:rate)}"),
                               number_with_delimiter( "#{sub}"),
                           ]
    end


    total =   "%.2f" % total
    if counter != 0
      grand_total = "%.2f" % @prescription.total
      formatted_table.push [
                               "",
                               "",
                               "",
                               "Total(N)",
                               number_with_delimiter( "#{grand_total}" )
                           ]
    end
    formatted_table
    formatted_table
  end

end
