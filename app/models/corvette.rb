class Corvette < ActiveRecord::Base

  has_attached_file :photo,
                    :styles => {
                      :thumb => ["72x72#"],
                      :medium => ["250x250#"]
                    },
                    :default_url => '/images/default_corvette.png',
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "cs446/illogicians/#{Rails.env}/:attachment/:id/:style.:extension"

  belongs_to :creator, :class_name => "User"

  def to_s
    name
  end
  
end