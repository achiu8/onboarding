class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string  :from
      t.string  :to
      t.string  :subject
      t.text    :body
      t.boolean :read, default:false
      t.timestamps
    end

    add_index(:emails, :from)
    add_index(:emails, :to)
  end
end
