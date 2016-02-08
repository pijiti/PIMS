require 'prawn'
require 'prawn/table'

class Voucher

  def initialize(order,dest,current_user)
    @document     = Prawn::Document.new
    @order        = order
    @dest         = dest
    @current_user = current_user
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
    @document.repeat([1]) do
      @document.grid([0,0], [6, 11]).bounding_box do
        @document.text_box "<strong><font size='17'>State Specialist Hospital,Ondo.\nPharmacy Department</font></strong>\n<font size='11'>Store Requisition & Issue Voucher (SRV)</font>", {
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
    @document.grid([2,0], [35, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def footer_content
    @document.grid([32,0], [35, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def write_order_information
    page_content do
    @document.pad_top 5 do
      @document.move_down 50
      @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
      @document.pad_top 2.5 do
        @document.text_box "Date Printed: #{Time.now.strftime("%d/%m/%Y %H:%M:%S")}", {
            size:  9,
            leading: 0,
            width: 230,
            height: 40,
            at: [@document.cursor + 35, @document.bounds.top],
            color: '000000'
        }
        @document.text_box "Ordering Dispensary: #{@order.from_store.name}", {
            size: 9,
            at: [@document.bounds.right - 260, @document.bounds.top + 30],
            width: 230,
            height: 40,
            inline_format: true,
            align: :right,
            valign: :center,
            leading: 5
        }
      end

      @document.pad_top 5 do
        @document.indent 1 do
          @document.text_box "Order No: #{@order.number}", {
              size:  9,
              at: [@document.cursor + 35, @document.bounds.top + 15],
              inline_format: true,
              leading: 0,
              width: 230,
              height: 40,
              color: '000000'
          }

          @document.text_box "Ordering Personel: #{@order.ordered_by.try(:first_name)} #{@order.ordered_by.try(:last_name)}", {
              size: 9,
              at: [@document.bounds.right - 260, @document.bounds.top + 15],
              width: 230,
              height: 40,
              inline_format: true,
              align: :right,
              valign: :center,
              leading: 5
          }
        end
      end

      #@document.move_down(15)

    #  @document.pad_top 5 do
    #    @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
    #    @document.pad_top 2.5 do
    #      @document.indent 50 do
    #      @document.text "Consign to: #{@order.from_store.name}", {
    #          size:  10,
    #          leading: 0,
    #          color: '000000'
    #      }
    #        end
    #    end
    #    @document.pad_top 5 do
    #      @document.indent 50 do
    #        @document.text "Serviced from : #{@order.service_requests.last.try(:request_store).try(:name)}", {
    #            size:  10,
    #            inline_format: true,
    #            leading: 0,
    #            color: '000000'
    #        }
    #      end
    #    end
    #  end
    #end
      end
  end
end
end

def write_service_requests
  page_content do
    @document.move_down 70
    @document.pad_top 10 do
      @document.table get_table_data,{
          header: true,
          position: :center,
          width: @document.bounds.right - 60,
          column_widths: [40, 130, 100, 70, 70,70],
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
  write_signature_content
  end
end
#
#def signature_line(label:,sign:)
#  @document.bounding_box [0, @document.cursor], {
#      width: @document.bounds.right,
#      height: 45
#  } do
#  if sign
#    @document.bounding_box [0,(@document.cursor - 20)],{
#        width: @document.bounds.right,
#        height: 30
#    }do
#    @document.text "#{sign}",size: 10,color: 'ffffff'
#  end
#end
#
#end
#end

def get_table_data
  formatted_table = []
  formatted_table.push [
                           'S/N',
                           'Item',
                           'Brand',
                           'Batch No',
                           'Qty Req',
                           'Qty Issued'
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
    #end
   end
  formatted_table
end

  #
  # Private: Write the bottom footer section to all pages utilizing the last grid row and all columns.
  #
  def write_page_footers
    (1..@document.page_count).each do |i|
      @document.go_to_page i
      @document.grid([0,0], [0,5]).bounding_box do
        @document.text_box "#{i} of #{@document.page_count}", {
            align:  :left,
            valign: :bottom,
            at: [@document.bounds.left + 35, @document.bounds.top + 15],
            size: 10,
        }
      end
    end
    #footer_content do
    #end
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
      @document.rectangle [@document.bounds.left + 50 ,  @document.cursor + 50], 138, 1
    end
    @document.text_box "", {
        align: :left,
        at: [@document.bounds.left + 50 , @document.cursor + 62],
        size: 10,
        style: :italic
    }
    @document.text_box "Store Keeper Name", {
        align: :left,
        at: [@document.bounds.left + 50 , @document.cursor + 42],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 350, @document.cursor + 50], 117, 1
    end
    @document.text_box "Receiver Name", {
        align: :left,
        at: [@document.bounds.left + 350 , @document.cursor + 42],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 50, @document.cursor - 12], 138, 1
    end
    @document.text_box "Store Keeper's Signature/Date", {
        align: :left,
        at: [@document.bounds.left + 50, @document.cursor - 20],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 350, @document.cursor - 12], 117, 1
    end
    @document.text_box "Receiver's Signature/Date", {
        align: :left,
        at: [@document.bounds.left + 350, @document.cursor - 20],
        size: 10,
        style: :italic
    }
end
end