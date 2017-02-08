require 'restaurant'
require 'helpers/string_extend'

class Guide

  class Config
    @@actions = ['list','find', 'add', 'quit']

    def self.actions
      @@actions
    end
  end

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant.txt file."
      # or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant.txt file."
      # exit if create fails
    else
      puts "Exiting.\n\n"
      exit!
    end
  end

  def launch!
    introduction
    # action loop
    result = nil
    until result ==:quit
      action = get_action
      result = do_action(action )
    end
    conclusion
  end

  def get_action
    action = nil

    # request input until valid action is submitted
    until Guide::Config.actions.include?(action)
      puts 'Actions:' + Guide::Config.actions.join(', ') if action
      print '> '
      user_response = gets.chomp
      action = user_response.downcase.strip
    end

    return action
  end

  def do_action(action)
    case action
      when 'list'
        list
      when 'find'
        puts 'Finding...'
      when 'add'
        add
      when 'quit'
        return :quit
      else
        puts "\n I didn't get that command...\n"
        
    end
  end

  def list
    puts "\n Listing joints... \n\n".upcase

    restaurants = Restaurant.saved_restaurants
    output_restaurant_table(restaurants)
  end

  def find

  end

  def add
    output_action_header('Add a joint')

    restaurant = Restaurant.build_query

    if restaurant.save
      puts "\nJoint added to listing!\n\n"
    else
      puts "\nError: Joint not added.\n\n"
    end
  end

  def introduction
    puts "\n\n<<< Welcome to the Food Radar! >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave.\n\n"
  end

  def conclusion
    puts "\n<<< Goodbye and enjoy your meal! >>>\n\n\n"
  end
  
  private
  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6)
    print " " + "Location".rjust(20)+ "\n"
    puts "-" * 81
    restaurants.each do |restaurant|
      line =  " " << restaurant.name.titleize.ljust(30)
      line << " " + restaurant.cuisine.titleize.ljust(20)
      line << " " + restaurant.formatted_price.ljust(6)
      line << " " + restaurant.location.titleize.rjust(20)
      puts line
    end
    puts "No joints found" if restaurants.empty?
    puts "-" * 81
  end

end
