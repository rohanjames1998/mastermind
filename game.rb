require 'pry-byebug'

#-------------------------------------#
# MODULES
#-------------------------------------#
module GameFunctions

    def get_player_response
        loop do
            input = gets.downcase
            if input.include?(',')
                return input.split(',')
            else
                puts "Please separate color names with commas"
                next
            end
        end
    end

    def generate_feedback(player_input)
        comp_response = []

        player_input.each_with_index do |input, index|
            case
            when input[index] == code[index]
                reply = 'Correct!, '
                comp_response << reply
                next
            when code.include(input)
                reply = 'Incorrect place, '
                comp_response << reply
                next
            else
                reply = 'Try again, '
                comp_response << reply
            end
        end
        puts comp_response.join
    end


end

#-------------------------------------#
# CLASSES
#-------------------------------------#
class Game

    extend GameFunctions

    @@colors = ['green', 'blue','red', 'yellow', 'purple', 'orange', 'black', 'white']
    @@rounds = 0
    def initialize
        @code = @@colors.shuffle[0..3]
# binding.pry

        Game.round
    end

    attr_reader :code, :guess

    def self.round
        @@rounds += 1
        player_input = get_player_response
        generate_feedback(player_input)
    end
end


#-------------------------------------#
# GAME
#-------------------------------------#
puts "Hello and welcome to mastermind!",
"In this game 4 colors will be randomly selected from the list of colors given below.",
"Green, Blue, Red, Yellow, Purple, Orange, Black, White",
"You will get 12 guesses to guess the colors in correct order"
"Good Luck!!!"
Game.new

