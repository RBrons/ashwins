class AddBreakpointToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_breakpoint, :decimal
  end
end
