class PenName < ActiveRecord::Base
  belongs_to :author

  def name
    [first_name, last_name].join(' ')
  end
end
