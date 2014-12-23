class Email < ActiveRecord::Base
  has_many :emails_label
  has_many :labels, through: :emails_label

  def mark_read!
    self.read = true
    self.save
  end

  def as_summary_json
    {from:from, to:to, subject:subject, id:id, read:read, created_at:created_at}
  end

  def as_json(opts={})
    as_summary_json.merge(body:body)
  end
end
