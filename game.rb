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

    def comp_guess(colors)
      colors.shuffle!
      guess = colors[0...4]
      puts guess
      loop do
        player_feedback = get_player_feedback
      end
    end

    def get_player_feedback
        possible_feedbacks = ['wrong', 'correct', 'incorrect place']

        #Checking for commas
        loop do
            index = 0
            correct_response_indicator =  0
      feedback = gets.chomp.downcase
      if feedback.include?(',')
        feedback = feedback.split(',')
      else
        puts "Please separate your feedback using commas"
        next
			end
        #Getting the feedback and checking it it contains specified responses
        possible_feedbacks.each do |f|
            if feedback[index] == f
                correct_response_indicator += 1
								index += 1
						else
							index += 1
						end
      end
			if correct_response_indicator == 4
				return feedback
			else
				puts "Please only enter specified feedback responses (Wrong, Correct, Incorrect place)"
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

				#Break scenarios
        if make_or_break.include?('break')
        puts  "\nIn this game 4 colors will be randomly selected from the list of colors given below.",
"Green, Blue, Red, Yellow, Purple, Orange, Black, White",
"You will get 12 guesses to guess the colors in correct order"
"Good Luck!!!\n"
            @code = @@colors.shuffle[0...4]
        player_guess_round

				# Make scenarios
        elsif make_or_break.include?('make')
          puts "\nYou have chosen to make the code",
              "The computer will get 12 guesses to crack your code",
              "After each guess you have to give appropriate responses to the computer about the guess",
              "\n-----FEEDBACK GUIDE-----",
              "\nYou can format your response as so:",
              "\nCorrect, Wrong, Wrong, Incorrect place",
              "\nCorrect means the color is in its correct place",
              "Wrong means the color doesn't exist in the code",
              "Incorrect place means the color exists in the code but is not in the correct place",
              "Please separate each response with commas like shown above",
              "\n Please enter your code below"


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

    def comp_guess_round
        loop do
            rounds += 1
            comp_input = comp_guess
				end
			end


    protected

    attr_reader :code

end


#-------------------------------------#
# GAME
#-------------------------------------#
puts "Hello and welcome to mastermind!",
    "Do you want to break the code? Or make the code?"
new_game = Game.new
new_game.round

