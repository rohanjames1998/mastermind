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
					# We need to remove whitespace in order to correctly compare
        code = gets.chomp.downcase.gsub(/\s+/, '').split(',')
        if code.all? {|ele| color_array.include?(ele)} && code.length == 4
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
			#We first get a random guess for computer then we separate them into two parts one will be guess and other
			#we will use to exchange incorrectly placed colors
      colors.shuffle!
      guess = colors[0...4]
			rest_colors = colors[4...8]
      loop do
				# Since guess is an array we need to process it before displaying it on console
        @@rounds += 1
				display_comp_guess(guess)
        player_feedback = get_player_feedback
				break if player_feedback.all?('correct') || player_feedback == 'you win' || @@rounds == 12

        #Since we are shuffling incorrectly placed colors we need to separate the loop for wrong and incorrectly placed
        #colors. Else we will delete wrong colors and shuffle wrong colors.
				player_feedback.each_with_index do |f, i|
						#Since feedbacks correspond to array we can use its indices to mutate our guess array
						#If the color  is wrong we delete it
					if f == 'wrong'
						guess.delete_at(i)
						# Then we insert a color from rest of the colors we discarded earlier
            new_color = rest_colors.delete_at(0)
						guess.insert(i, new_color)
          end
        end
						# If color is at incorrect place we generate a random index number then place the color there
						# If the color there is correct then we generate a new index number for color placement
            player_feedback.each_with_index do |f, i|
					if f == 'incorrectplace'
						loop do
							random_index = rand(4)
							# binding.pry
							if player_feedback[random_index] == 'correct' || random_index == i
								next
							else
                misplaced_color = guess.delete_at(i)
								guess.insert(random_index, misplaced_color)
                break
							end
						end
					end
				end
			end
      make_end_screen(@@rounds)
    end

    def make_end_screen(rounds)
      if rounds == 12
        puts "The computer, after #{rounds} couldn't break your code.",
        "Congratulations, you have won the game!!."
      else
        puts "It took computer #{rounds} tries to break your code."
            "Better luck next time."
      end
    end

		def display_comp_guess(guess)
			display_guess = ''
			guess.map do |color|
				unless color == guess[guess.length - 1]
					color += ','
					color += ' '
				end
				display_guess += color
			end
			puts "\nComputer guess is", display_guess
		end

    def get_player_feedback
        possible_feedbacks = ['wrong', 'w', 'correct', 'c', 'incorrectplace', 'ic', 'help', 'mycode']

        #Checking for commas
        loop do
            correct_response_indicator =  0
      feedback = gets.chomp.gsub(/\s+/, '').downcase
      feedback.each_with_index  do |f, i|
        case f
        when 'help'
          guidelines
          feedback.delete_at(i)
        when 'mycode'
          puts @@code
          feedbacks.delete_at(i)
        end
      end
      if feedback.include?(',')
        feedback = feedback.split(',')
      else
        puts "Please separate your feedback using commas"
        next
			end
        #Getting the feedback and checking it it contains specified responses
        feedback.each do |f|
            if possible_feedbacks.include?(f)
                correct_response_indicator += 1
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

def guidelines
  puts "\n-----FEEDBACK GUIDE-----",
  "\n1. You can format your response as so:",
  "\nCorrect, Wrong, Wrong, Incorrect place",
  "\nOR you can also abbreviate your responses like:"
  "\n C, W, W, IC"
  "\na) Correct/C means the color is in its correct place",
  "b)Wrong/W means the color doesn't exist in the code",
  "c)Incorrect place/IC means the color exists in the code but is not in the correct place",
  "d)Please separate each response with commas like shown above"
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
				break

				# Make scenarios
        elsif make_or_break.include?('make')
          puts "\nYou have chosen to make the code",
              "The computer will get 12 guesses to crack your code",
              "After each guess you have to give appropriate responses to the computer about the guess",
              "\n-----FEEDBACK GUIDE-----",
              "\n1. You can format your response as so:",
              "\nCorrect, Wrong, Wrong, Incorrect place",
              "\nOR you can also abbreviate your responses like:"
              "\n C, W, W, IC"
              "\na) Correct/C means the color is in its correct place",
              "b)Wrong/W means the color doesn't exist in the code",
              "c)Incorrect place/IC means the color exists in the code but is not in the correct place",
              "d)Please separate each response with commas like shown above",
              "\n Please enter your code below"


            @code = get_player_code(@@colors)
						comp_guess(@@colors)
						break
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

