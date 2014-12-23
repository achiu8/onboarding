class Label < ActiveRecord::Base
  has_many :emails_label
  has_many :emails, through: :emails_label

  def as_json(opts={})
    {color: color, name: name, id:id}
  end
end
