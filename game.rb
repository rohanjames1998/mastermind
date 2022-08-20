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

    def generate_comp_feedback(player_input)
        comp_response = []

        player_input.each_with_index do |input, index|
            case
            when input[index] == code[index]
                reply = 'Correct!, '
                comp_response << reply
                next
            when code.include?(input)
                reply = 'Incorrect place, '
                comp_response << reply
                next
            else
                reply = 'Wrong Color, '
                comp_response << reply
            end
        end
        puts comp_response.join
    end

    def end_game?(player_input, rounds)
        if player_input == code
           puts "\nCongratulations!, You just cracked the code!"
           return true
        elsif rounds == 12
          puts  "\nSorry you are out of guesses",
            "The code was: #{code}",
            "Better Luck Next Time"
            return true
        end
    end

     def get_player_code(color_array)
        loop do
        code = gets.chomp.downcase.split(',')
        # binding.pry
        if code.all? {|ele| color_array.include?(ele)}
            return code
        else
            puts "\nPlease enter a valid 4 color code separated by commas.",
            "You can choose any 4 color out of the following:",
            "\n #{color_array.join(' ')}"
            next
        end
      end
    end

end

#-------------------------------------#
# CLASSES
#-------------------------------------#
class Game

    include GameFunctions


    @@colors = ['green', 'blue','red', 'yellow', 'purple', 'orange', 'black', 'white']
    @@rounds = 0
    def initialize
        loop do
        make_or_break = gets.downcase
        if make_or_break.include?('break')
            @code = @@colors.shuffle[0..3]
        player_guess_round
        elsif make_or_break.include?('make')
            @code = get_player_code(@@colors)
        else
            puts "Please enter a valid response (Your response should include 'Make' or 'Break')"
        end
      end
    end


    def player_guess_round
        loop do
            @@rounds += 1
            player_input = get_player_response
            generate_comp_feedback(player_input)
            break if end_game?(player_input, @@rounds) == true
        end
    end

    # def comp_guess_round

    protected

    attr_reader :code

end


#-------------------------------------#
# GAME
#-------------------------------------#
puts "Hello and welcome to mastermind!",
"In this game 4 colors will be randomly selected from the list of colors given below.",
"Green, Blue, Red, Yellow, Purple, Orange, Black, White",
"You will get 12 guesses to guess the colors in correct order"
"Good Luck!!!\n"
new_game = Game.new
new_game.round

