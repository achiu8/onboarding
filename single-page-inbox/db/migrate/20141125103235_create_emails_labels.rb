class CreateEmailsLabels < ActiveRecord::Migration
  def change
    create_join_table :emails, :labels
  end
end
