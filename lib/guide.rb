class Guide

  def initialize(path = nil)

  end

  def launch!
    introduction

    conclusion
  end

  def introduction
    puts "\n\n <<< Welcome to the Food Radar >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave. \n\n"
  end

  def conclusion
    puts "\n <<< Goodbye and enjoy your meal! >>> \n\n\n"
  end
end