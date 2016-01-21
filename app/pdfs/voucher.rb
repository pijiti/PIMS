require 'prawn'
require 'prawn/table'

class Voucher

  def initialize(order,dest)
    @document = Prawn::Document.new
    @order    = order
    @dest     = dest
  end

  def generate
    create_grid
    #disable_font_errors
    write_page_headers
    write_order_information
    write_service_requests
    write_page_footers
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
        rows:    36,
        gutter:  10
    )
  end

  #
  # Private: Disabled Prawn error generation for UTF-8 and international characters with the base .afm font
  #
  def disable_font_errors
    Prawn::Font::AFM.hide_m17n_warning = true
  end

  #
  # Private: Write the top header section to all pages utilizing the first two grid rows and all columns.
  #
  def write_page_headers
    @document.repeat(:all) do
      @document.grid([0,0], [3, 11]).bounding_box do
        @document.text_box "<strong><font size='17'>State Specialist Hospital, Ondo Pharmacy Department</font></strong>\n" + "<font size='13'>Store Requisition and Issue Voucher (SRV)</font>", {
            align:         :center,
            valign:        :top,
            leading:       5,
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
    @document.grid([4,0], [33, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def write_order_information
    page_content do
    @document.pad_top 5 do
      @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
      @document.pad_top 2.5 do
        @document.text_box "Order No: #{@order.number}", {
            size:  10,
            leading: 0,
            width: 170,
            height: 40,
            at: [@document.cursor + 50, @document.bounds.top],
            color: '000000'
        }
        @document.text_box "Date Printed: #{Time.now.strftime("%d/%m/%Y")}", {
            size: 10,
            at: [@document.bounds.right - 230, @document.bounds.top + 30],
            width: 170,
            height: 40,
            inline_format: true,
            align: :right,
            valign: :center,
            leading: 5
        }
      end

      @document.pad_top 5 do
        @document.indent 1 do
          @document.text_box "Order Date: #{@order.updated_at.strftime("%d/%m/%Y")}", {
              size:  10,
              at: [@document.cursor + 50, @document.bounds.top + 15],
              inline_format: true,
              leading: 0,
              width: 170,
              height: 40,
              color: '000000'
          }

          @document.text_box "Time Printed: #{Time.now.strftime("%H:%M:%S")}", {
              size: 10,
              at: [@document.bounds.right - 230, @document.bounds.top + 15],
              width: 170,
              height: 40,
              inline_format: true,
              align: :right,
              valign: :center,
              leading: 5
          }
        end
      end

      @document.move_down(15)

      @document.pad_top 5 do
        @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
        @document.pad_top 2.5 do
          @document.indent 50 do
          @document.text "Requesting Store: #{@order.organization_name}", {
              size:  10,
              leading: 0,
              color: '000000'
          }
            end
        end
        @document.pad_top 5 do
          @document.indent 50 do
            @document.text "Servicing Store: #{@order.organization_address}", {
                size:  10,
                inline_format: true,
                leading: 0,
                color: '000000'
            }
          end
        end
      end
    end
      end
  end
end
end

def write_service_requests
  page_content do
    @document.move_down(75)
    @document.pad_top 10 do
      @document.table get_table_data,{
          header: true,
          position: :center,
          width: @document.bounds.right - 60,
          column_widths: [40, 130, 100, 70, 70,70],
          cell_style: {
          padding: [4, 10, 10, 10],
          size: 10,
          border_width: 0.5,
          border_color: '000000',
          valign: :center
      }
      } do

    end
  end
  end
end

def signature_line(label:,sign:)
  @document.bounding_box [0, @document.cursor], {
      width: @document.bounds.right,
      height: 45
  } do
  if sign
    @document.bounding_box [0,(@document.cursor - 20)],{
        width: @document.bounds.right,
        height: 30
    }do
    @document.text "#{sign}",size: 10,color: 'ffffff'
  end
end

end
end

def get_table_data
  formatted_table = []
  formatted_table.push [
                           'S/N',
                           'Generic',
                           'Brand',
                           'Batch No',
                           'Qty Requested(Packs:Units)',
                           'Qty Given(Packs:Units)'
                       ]
    counter = 0
  @order.service_requests.each do |s|
    counter += 1
    s.receipts.each do |r|
      formatted_table.push [
                               counter,
                               s.pharm_item.try(:name),
                               r.batch.try(:brand).try(:name),
                               r.batch.try(:batch_number),
                               r.qty,
                               r.received_qty
                           ]
    end
  end
  formatted_table
end

  #
  # Private: Write the bottom footer section to all pages utilizing the last grid row and all columns.
  #
  def write_page_footers
    (1..@document.page_count).each do |i|
      @document.go_to_page i
      @document.grid([34,0], [35,1]).bounding_box do
        @document.text_box "#{i} of #{@document.page_count}", {
            align:  :left,
            valign: :bottom,
            at: [@document.bounds.left + 50, @document.bounds.top + 15],
            size: 10,
        }
      end
    end

    #@document.grid([7,1], [7,2]).bounding_box do
      @document.fill_color '000000'
      @document.fill do
        @document.rectangle [@document.bounds.left + 150, @document.bounds.bottom + 20], 138, 1
      end
      @document.text_box "Store Keeper's Signature/Date", {
          align: :left,
          valign: :bottom,
          at: [@document.bounds.left + 150, @document.bounds.top + 15],
          size: 10,
          style: :italic
      }
    #end

    #@document.grid([34,10], [35,11]).bounding_box do
      @document.fill_color '000000'
      @document.fill do
        @document.rectangle [@document.bounds.left + 380, @document.bounds.bottom + 20], 117, 1
      end
      @document.text_box "Receiver's Signature/Date", {
          align: :left,
          valign: :bottom,
          at: [@document.bounds.left + 380, @document.bounds.top + 15],
          size: 10,
          style: :italic
      }
    #end
  end
end