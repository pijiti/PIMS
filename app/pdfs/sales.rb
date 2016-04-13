require 'prawn'
require 'prawn'
require 'prawn/table'
include ActionView::Helpers::NumberHelper

class Sales

  def initialize(dest, current_user, current_store, receipts, total, manage_report)
    @document      = Prawn::Document.new
    @current_user  = current_user
    @current_store = current_store
    @receipts      = receipts
    @total         = total
    @manage_report = manage_report
    @dest          = dest
  end

  def generate
    create_grid
    write_page_headers
    write_store_info
    write_service_requests
    # write_page_footers
    @document.render_file @dest
    @dest
  end

  private

  #
  # Private: Create the document-wide grid utilized for content placement. It consists of 12 rows, 12 columns, with 10pt gutters.
  #
  def create_grid
    @document.define_grid(
        columns: 12,
        rows: 36,
        gutter: 10
    )
  end

  #
  # Private: Write the top header section to all pages utilizing the first two grid rows and all columns.
  #
  def write_page_headers
    @document.repeat([1]) do
      @document.grid([0, 0], [6, 11]).bounding_box do
        @document.text_box "<strong><font size='17'>State Specialist Hospital,Ondo.\nPharmacy Department</font></strong>\n<font size='11'>Sales</font>", {
            align: :center,
            valign: :top,
            leading: 5,
            inline_format: true,
            size: 10,
            at: [@document.bounds.left, @document.bounds.top - 12]
        }
      end
    end
  end

  #
  # Private: Write the content provided in the block into the 3rd through 11th rows and all columns.
  #
  def page_content
    @document.grid([2, 0], [35, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def footer_content
    @document.grid([32, 0], [35, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def write_store_info
    page_content do
      @document.pad_top 5 do
        @document.move_down 50
        @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
         
        end
      end
    end
  end

  def write_service_requests
    p @document.bounds.right
    page_content do
      @document.move_down 60
      @document.pad_top 10 do
        column_widths = @manage_report ? [40, 130, 100, 40, 40,40,30] : [60, 100, 80, 140, 30]
        @document.table get_table_data, {
            header: true,
            position: :center,
            width: @document.bounds.right + 200,
            cell_style: {
                padding: [4, 10, 10, 10],
                size: 10,
                border_width: 1,
                border_color: '000000',
                valign: :center
            }
        } do
          row(0).style do |c|
            c.font_style = :bold
            c.border_width = 2
            c.border_color = '000000'
          end
        end
      end
      # write_signature_content
    end
  end

  def get_table_data
    formatted_table = []
    if @manage_report
      formatted_table.push [
                             'Name of Patient',
                             'Hospital Unit',
                             'Transaction date',
                             'Items bought',
                             'Subtotal(N)',
                             'Surcharges(N)',
                             'Total(N)'
                         ]
    else
      formatted_table.push [
                             'Name of Patient',
                             'Hospital Unit',
                             'Transaction date',
                             'Items bought',
                             'Subtotal(N)'
                         ]
    end
    @receipts.each do |r|
      if @manage_report
        formatted_table.push [
                                   r.patient.name,
                                   r.hospital_unit.try(:name),
                                   r.updated_at.strftime(" %m-%d-%Y  at %I:%M%p"),
                                   get_inner_table(r),
                                   number_to_currency(r.subtotal ,unit: ""),
                                   number_to_currency(r.surcharges ,unit: ""),
                                   number_to_currency(r.total ,unit: "")
                               ]
      else
       formatted_table.push [
                                   r.patient.name,
                                   r.hospital_unit.try(:name),
                                   r.updated_at.strftime(" %m-%d-%Y  at %I:%M%p"),
                                   get_inner_table(r),
                                   number_to_currency(r.subtotal ,unit: "")
                               ]
      end
    end
    formatted_table
  end

  def get_inner_table(receipt)
    inner_table = []
    inner_table.push [
                             'Brand',
                             'Units'
                         ]
    receipt.prescription_batches.each do |pb|
      inner_table.push [
          pb.brand.drug_prescription_info,
          pb.qty
      ]
    end
    inner_table
  end

  #
  # Private: Write the bottom footer section to all pages utilizing the last grid row and all columns.
  #
  def write_page_footers
    (1..@document.page_count).each do |i|
      @document.go_to_page i
      @document.grid([0, 0], [0, 5]).bounding_box do
        @document.text_box "#{i} of #{@document.page_count}", {
            align: :left,
            valign: :bottom,
            at: [@document.bounds.left + 35, @document.bounds.top + 15],
            size: 10,
        }
      end
    end
    #footer_content do
    #end
  end

  def write_signature_content
    @document.move_down 120
    if @document.y.to_f < 100
      @document.start_new_page
      @document.move_down(50)
    end

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 50, @document.cursor + 50], 138, 1
    end
    @document.text_box "", {
        align: :left,
        at: [@document.bounds.left + 50, @document.cursor + 62],
        size: 10,
        style: :italic
    }
    @document.text_box "In Charge Name", {
        align: :left,
        at: [@document.bounds.left + 50, @document.cursor + 42],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 350, @document.cursor + 50], 117, 1
    end
    @document.text_box "Receiver Name", {
        align: :left,
        at: [@document.bounds.left + 350, @document.cursor + 42],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 50, @document.cursor - 12], 138, 1
    end
    @document.text_box "In Charge Signature & Date", {
        align: :left,
        at: [@document.bounds.left + 50, @document.cursor - 20],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 350, @document.cursor - 12], 117, 1
    end
    @document.text_box "Receiver's Signature & Date", {
        align: :left,
        at: [@document.bounds.left + 350, @document.cursor - 20],
        size: 10,
        style: :italic
    }
  end
end