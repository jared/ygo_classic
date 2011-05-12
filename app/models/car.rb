class Car < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :work_orders do
    def search(query)
      find(:all, :include => :line_items, :conditions => ["notes LIKE ? OR line_items.description LIKE ?", "%"+query+"%", "%"+query+"%"]).sort { |a,b| b.date <=> a.date }
    end
    
    def ordered
      find(:all).sort { |a,b| b.date <=> a.date }
    end
  end
  has_many :line_items, :through => :work_orders
  
  # attr_protected :user_id
  
  validates_presence_of :make, :model, :color, :user_id
  validates_numericality_of :year, :message => "must be a number."
  
  class <<self

    def find(*args)
      case args.first.to_s
      when "random"
        ids = connection.select_all("SELECT id FROM cars WHERE private != 1")
        super(ids[rand(ids.length)]["id"].to_i)
      when "featured"
        # TODO: Implement featured find
        # Week numbers drive which feature.
        # Weeks evenly divisible by 4 = Most worked-on
        # Weeks evenly divisible by 3 = Highest mileage
        # Weeks evenly divisible by 2 = Most money spent on repairs
        # Weeks evenly divisible by 1 = Oldest
      else
        super
      end
    end

  end
  
  def name
    "#{self.year} #{self.make} #{self.model}"
  end
  
  def short_name
    if self.make.length > 6
      make_abbrev = self.make[0,4]
    else
      make_abbrev = self.make
    end
    "#{self.year} #{make_abbrev} #{self.model}"
  end
  
end

