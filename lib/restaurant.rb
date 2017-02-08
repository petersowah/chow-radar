class Restaurant

  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  attr_accessor :name, :cuisine, :price, :location

  def self.file_exists?
    # class should know if the restaurant file exists
    if @@filepath && File.exist?(@@filepath)
      return true
    else
      return false
    end
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exist?(@@filepath)
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
    # read the restaurant file
    # return instances of restaurant
  end

  def self.build_query
    args = {}

    print "\n Enter restaurant name: "
    args[:name] = gets.chomp
    print "\n Enter cuisine type: "
    args[:cuisine] = gets.chomp
    print "\n Enter restaurant location: "
    args[:location] = gets.chomp
    print "\n Enter restaurant average price: "
    args[:price] = gets.chomp

    return self.new(args)
  end

  def initialize(args = {})
    @name = args[:name] || ''
    @cuisine = args[:cuisine] || ''
    @location = args[:location] || ''
    @price = args[:price] || ''
  end

  def save
    return false unless Restaurant.file_usable?

    # Open file and append
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price, @location].join("\t")} \n"
    end
    return true
  end

end