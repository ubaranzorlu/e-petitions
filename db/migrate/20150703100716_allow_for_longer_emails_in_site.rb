class AllowForLongerEmailsInSite < ActiveRecord::Migration[4.2]
  def up
    change_column :sites, :email_from, :string, limit: 100, default: '"Petitions: UK Government and Parliament" <no-reply@demokra.si>'
    change_column :sites, :feedback_email, :string, limit: 100, default: '"Petitions: UK Government and Parliament" <feedback@demokra.si>'
  end

  def down
    change_column :sites, :email_from, :string, limit: 50, default: 'no-reply@demokra.si'
    change_column :sites, :feedback_email, :string, limit: 100, default: 'feedback@demokra.si'
  end
end
