require 'prawn'
require 'prawn/table'

class InventoryVoucher

  def initialize(dest,current_user,store = nil, generic = nil, brand = nil)
    @document     = Prawn::Document.new
    @inventory    = Inventory.includes(:store, :brand, :batches, :inventory_batches, :pharm_item, pharm_item: [:brands], inventory_batches: [:batch], store: [:parent], batches: [:brand]).order("pharm_items.name ASC").all
    @inventory    = @inventory.where(:store_id => store) if !store.blank?
    @inventory    = @inventory.where(:pharm_item_id => generic) if !generic.blank?
    @inventory    = @inventory.where(:brand_id => brand) if !brand.blank?
    @store        = store
    @generic      = generic
    @brand        = brand
    @dest         = dest
    @current_user = current_user
  end

  def generate
    create_grid
    write_page_headers
    write_store_info
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
  # Private: Write the top header section to all pages utilizing the first two grid rows and all columns.
  #
  def write_page_headers
    @document.repeat(:all) do
      @document.grid([0,0], [6, 11]).bounding_box do
        @document.text_box "<strong><font size='17'>State Specialist Hospital,Ondo.\nPharmacy Department</font></strong>\n<font size='11'>Inventory Balance</font>", {
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
    @document.grid([5,0], [31, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def footer_content
    @document.grid([32,0], [36, 11]).bounding_box do
      @document.pad_top 10 do
        yield
      end
    end
  end

  def write_store_info
    page_content do
    @document.pad_top 5 do
      @document.bounding_box([0, @document.cursor], width: @document.bounds.right) do
      @document.pad_top 2.5 do
        @document.text_box "Date & Time: #{Time.now.strftime('%d-%m-%Y  at %I:%M%p')}", {
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
          @document.text_box "Store Name: #{@store.try(:name)}", {
              size:  9,
              at: [@document.cursor + 35, @document.bounds.top + 15],
              inline_format: true,
              leading: 0,
              width: 230,
              height: 40,
              color: '000000'
          }
        end
      end
      end
  end
end
end

def write_service_requests
  page_content do
    @document.move_down(20)
    @document.pad_top 10 do
      @document.table get_table_data,{
          header: true,
          position: :center,
          width: @document.bounds.right - 60,
          column_widths: [30, 100, 90, 70, 60,50,80],
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
  end
end

def get_table_data
  formatted_table = []
  formatted_table.push [
                           'S/N',
                           'Item',
                           'Brand',
                           'Batch No',
                           'Qty',
                           'Rate',
                           'Subtotal'
                       ]
  counter = 0
  total   = 0
  @inventory.each do |inventory|
    inventory.inventory_batches.where(:expired => nil).each do |ib|
    counter += 1
    total   +=  (ib.units*inventory.rate_per_unit)
    formatted_table.push [
                           counter,
                           inventory.pharm_item.name,
                           inventory.brand.name,
                           ib.batch.batch_number,
                           ib.units,
                           inventory.rate_per_unit,
                           (ib.units*inventory.rate_per_unit)
                         ]
        end
  end
  if counter != 0
    formatted_table.push [
                             "",
                             "",
                             "",
                             "",
                             "",
                             "Total",
                             total
                         ]
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
        # @document.text_box "#{i} of #{@document.page_count}", {
        #     align:  :left,
        #     valign: :bottom,
        #     at: [@document.bounds.left + 50, @document.bounds.top + 15],
        #     size: 10,
        # }
      end
    end

    footer_content do
    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 50 , @document.bounds.bottom + 80], 138, 1
    end
    @document.text_box @current_user.first_name + " " + @current_user.last_name, {
        align: :left,
        at: [@document.bounds.left + 50 , @document.bounds.bottom + 92],
        size: 10,
        style: :italic
    }
    @document.text_box "In Charge Name", {
        align: :left,
        at: [@document.bounds.left + 50 , @document.bounds.bottom + 72],
        size: 10,
        style: :italic
    }

    @document.fill_color '000000'
    @document.fill do
      @document.rectangle [@document.bounds.left + 350, @document.bounds.bottom + 80], 117, 1
    end
    @document.text_box "Receiver Name", {
        align: :left,
        at: [@document.bounds.left + 350 , @document.bounds.bottom + 72],
        size: 10,
        style: :italic
    }

      @document.fill_color '000000'
      @document.fill do
        @document.rectangle [@document.bounds.left + 50, @document.bounds.bottom + 20], 138, 1
      end
      @document.text_box "In Charge Signature & Date", {
          align: :left,
          valign: :bottom,
          at: [@document.bounds.left + 50, @document.bounds.top + 15],
          size: 10,
          style: :italic
      }

      @document.fill_color '000000'
      @document.fill do
        @document.rectangle [@document.bounds.left + 350, @document.bounds.bottom + 20], 117, 1
      end
      @document.text_box "Receiver's Signature & Date", {
          align: :left,
          valign: :bottom,
          at: [@document.bounds.left + 350, @document.bounds.top + 15],
          size: 10,
          style: :italic
      }
    end
  end
end