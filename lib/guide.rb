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
      action, args = get_action
      result = do_action(action, args)
    end
    conclusion
  end

  def get_action
    action, args = nil

    # request input until valid action is submitted
    until Guide::Config.actions.include?(action)
      puts 'Actions:' + Guide::Config.actions.join(', ') if action
      print '> '
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end

    return action, args
  end

  def do_action(action, args=[])
    case action
      when 'list'
        list
      when 'find'
        keyword = args.shift
        find(keyword)
      when 'add'
        add
      when 'quit'
        return :quit
      else
        puts "\n I didn't get that command...\n"
        
    end
  end

  # TODO: REFACTOR LIST METHOD
  def list(args=[])
    sort_order = args.shift
    sort_order ||= 'name'
    sort_order = 'name' unless %w['name', 'cuisine', 'price', 'location'].include?(sort_order)

    puts "\n Listing joints... \n\n".upcase

    restaurants = Restaurant.saved_restaurants

    restaurants.sort! do |restaurant1, restaurant2|
      case sort_order
        when 'name'
          restaurant1.name.downcase <=> restaurant2.name.downcase
        when 'cuisine'
          restaurant1.cuisine.downcase <=> restaurant2.cuisine.downcase
        when 'price'
          restaurant1.price.to_i <=> restaurant2.price.to_
      end
      end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine\n\n'"
  end

  # TODO : REFACTOR FIND METHOD
  def find(keyword='')
    output_action_header("Find a joint")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |restaurant|
        restaurant.name.downcase.include?(keyword.downcase) ||
            restaurant.cuisine.downcase.include?(keyword.downcase) ||
            restaurant.price.to_i <= keyword.to_i ||
            restaurant.location.downcase.include?(keyword.downcase)
      end
      output_restaurant_table(found)
    else
      puts 'Use a key phrase to find a joint from the list.'
      puts "Example: 'find fufu', 'find pizza', 'find kokonte', 'find tuo zaafi', 'find Ghana jollof', etc\n\n"
    end
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
