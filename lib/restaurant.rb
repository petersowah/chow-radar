class Restaurant

  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  attr_accessor :name, :cuisine, :price, :location

  def self.file_exists?
    # class should know if the restaurant file exists
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    # create the restaurant file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end

  def self.saved_restaurants
    # We have to ask ourselves, do we want a fresh copy each
    # time or do we want to store the results in a variable?
    restaurants = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
  end

  def self.build_using_questions
    args = {}
    print 'Enter Restaurant name: '
    args[:name] = gets.chomp.strip

    print 'Enter Cuisine type: '
    args[:cuisine] = gets.chomp.strip

    print 'Enter Average price: '
    args[:price] = gets.chomp.strip

    print 'Enter Location: '
    args[:location] = gets.chomp.strip

    return self.new(args)
  end

  def initialize(args={})
    @name    = args[:name]    || ''
    @cuisine = args[:cuisine] || ''
    @price   = args[:price]   || ''
    @location   = args[:location]   || ''
  end

  def import_line(line)
    line_array = line.split("\t")
    @name, @cuisine, @price, @location = line_array
    return self
  end

  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price, @location].join("\t")}\n"
    end
    return true
  end

end