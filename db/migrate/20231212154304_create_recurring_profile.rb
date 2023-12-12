class CreateRecurringProfile < ActiveRecord::Migration[7.0]
  def change
    create_table :recurring_profiles do |t|
      t.string     :frequency
      t.date       :ends_on
      t.integer    :ends_after_count
      t.boolean    :automatic_emails
      t.integer    :invoices_count, default: 0
      t.timestamps
    end

    add_column :invoices, :recurring_profile_id, :integer
    add_index  :invoices, :recurring_profile_id
  end
end
