class AddFeedbackEmailToSite < ActiveRecord::Migration[4.2]
  def change
    add_column :sites, :feedback_email, :string, limit: 100, null: false, default: 'feedback@demokra.si'
  end
end
