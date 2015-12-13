class LoadSequence < ActiveRecord::Migration
  def change
    Sequence.create(:number => "#{Order.last.number.split('-')[1].to_i + 1 }")
  end
end
