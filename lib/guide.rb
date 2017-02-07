require 'restaurant'
class Guide

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file."
      # or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant file."
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
      #   what do you want to do? (list, find, add, quit)
      print '> '
      user_response = gets.chomp

      #   do that action
      result = do_action(user_response)
    end
    conclusion
  end

  def do_action(action)
    case action
      when 'list', 'List'
        puts 'Listing...'
      when 'find', 'Find'
        puts 'Finding...'
      when 'add', 'Add'
        puts 'Adding'
      when 'quit', 'Quit','q'
        return :quit
      else
        puts "\n I didn't get that command...\n"
        
    end
  end

  def introduction
    puts "\n\n<<< Welcome to the Food Radar! >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave.\n\n"
  end

  def conclusion
    puts "\n<<< Goodbye and enjoy your meal! >>>\n\n\n"
  end

end
