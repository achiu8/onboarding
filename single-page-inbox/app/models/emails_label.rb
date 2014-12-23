class EmailsLabel < ActiveRecord::Base
  belongs_to :email
  belongs_to :label
end
