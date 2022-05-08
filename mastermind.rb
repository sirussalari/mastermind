class Board
    @@rows = {
        :first_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :second_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :third_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :fourth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :fifth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :sixth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :seventh_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :eigth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :ninth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :tenth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :eleventh_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ],
        :twelth_row => [
            ["_ _ _ _"],
            ["_ _ _ _"]
        ]
    }

    @@colors = [
        'blue',
        'green',
        'orange',
        'purple',
        'red',
        'yellow'
    ]

    def self.display_board
        puts "\n"
        for row in @@rows.values
            puts row.join('     ')
            puts "\n"
        end
    end

    def self.colors
        return @@colors
    end

    def self.add_colors(colors)
        for row in @@rows.values
            if row[0][0].include?('_')
                row[0][0] = colors.join(' ')
                break
            end
        end
    end

    def self.add_hints(hints)
        for row in 0...@@rows.values.length
            if @@rows.values[row][0][0].include?('_')
                @@rows.values[row - 1][1][0] = hints.join(' ')
                break
            end
        end

        Board.display_board

        if Player.instance.role == 'codebreaker'
            if hints.count('black') == 4
                puts "Congrats #{Player.instance.name}! You won!"
            elsif !@@rows[:twelth_row][0][0].include?('_')
                puts "Uh oh! Game over! \nThe correct sequence is: #{Computer.instance.code.join(' ')}"
            else
                puts "\n"
                Player.instance.choose_colors
            end
        end
    end

    def self.game_over?
        if Computer.guesses.keys.last == 12
            loop do
                puts "Is my final guess correct?"
                confirmation = gets.chomp

                if confirmation == "yes"
                    puts "Woohoo! I won!"
                    break
                elsif confirmation == "no"
                    puts "Oh man! Hopefully I get it next time..."
                    break
                end
            end
            
            return true
        end
    end

end

class Player
    attr_reader :name
    attr_reader :role
    
    def initialize(name, role)
        @@instance = self
        @name = name
        @role = role
    end

    def self.instance
        return @@instance
    end

    def verify_role
        if @role == 'codebreaker'
            self.choose_colors
        else
            self.code_maker
        end
    end

    def choose_colors
        color_choices = []
        loop do
            puts "Color choices: #{Board.colors.join(' ')}"
            puts "Choose first color: "
            first_color = gets.chomp
            if Board.colors.include?(first_color)
                color_choices.append(first_color)
                break
            end
        end

        loop do
            puts "Choose second color: "
            second_color = gets.chomp
            if Board.colors.include?(second_color)
                color_choices.append(second_color)
                break
            end
        end

        loop do
            puts "Choose third color: "
            third_color = gets.chomp
            if Board.colors.include?(third_color)
                color_choices.append(third_color)
                break
            end
        end

        loop do
            puts "Choose fourth color: "
            fourth_color = gets.chomp
            if Board.colors.include?(fourth_color)
                color_choices.append(fourth_color)
                break
            end
        end

        puts "You entered #{color_choices.join(' ')} as your guess.\nWould you like to make any changes?"
        confirmation = gets.chomp

        if confirmation == 'yes'
            self.choose_colors
        end

        Board.add_colors(color_choices)
        Computer.hints(color_choices)
    end

    def code_maker
        color_choices = []
        invalid_choice = "I'm sorry, I didn't catch that. Please enter a valid color choice."
        puts "Color choices: #{Board.colors.join(' ')}"
        puts "\nPlease enter the first color for your code: "
        first_color = gets.chomp
        
        while !Board.colors.include?(first_color)
            puts invalid_choice
            first_color = gets.chomp
        end

        puts "Please enter the second color for your code: "
        second_color = gets.chomp

        while !Board.colors.include?(second_color)
            puts invalid_choice
            second_color = gets.chomp
        end

        puts "Please enter the third color for your code: "
        third_color = gets.chomp
        
        while !Board.colors.include?(third_color)
            puts invalid_choice
            third_color = gets.chomp
        end

        puts "Please enter the fourth color for your code: "
        fourth_color = gets.chomp

        while !Board.colors.include?(fourth_color)
            puts invalid_choice
            fourth_color = gets.chomp
        end

        color_choices.append(first_color, second_color, third_color, fourth_color)
        Computer.code_breaker(nil)
    end

    def self.prompt_hints
        hints = []
        give_hints = nil
        confirmation = "Are there any hints you can give? (type 'yes' or 'no')"
        loop do
            puts confirmation
            give_hints = gets.chomp

            if give_hints == 'yes' or give_hints == 'no'
                break
            else
                confirmation = "I'm sorry, I didn't catch that. Please type 'yes' or 'no'"
            end
        end

        if give_hints == 'yes'
            ask_hint = "What is the first hint you can give? ('black' means that I got the color in the right spot, and 'white' means that I got a right color but it's not in the correct spot)"
            loop do
                puts ask_hint
                hint = gets.chomp

                if hint == 'white' or hint == 'black'
                    hints.append(hint)
                    break
                else
                    ask_hint = "I'm sorry, I didn't catch that. Please either type 'white' or 'black'"
                    hint = gets.chomp
                end
            end

            for i in 0...3
                puts "Is there another hint you can give?"
                confirmation = gets.chomp

                if confirmation == 'no'
                    break
                elsif confirmation == 'yes'
                    ask_hint = "What is the hint you can give?"
                    loop do
                        puts ask_hint
                        hint = gets.chomp

                        if hint == 'white' or hint == 'black'
                            hints.append(hint)
                            break
                        else
                            ask_hint = "I'm sorry, I didn't catch that. Please type 'white' or 'black'"
                            hint = gets.chomp
                        end
                    end
                else
                    puts "I'm sorry, I didn't catch that"
                end
            end

            Board.add_hints(hints)
            Computer.code_breaker(hints)

        elsif give_hints == 'no'
            Computer.code_breaker
        end
    end
end

class Computer
    attr_reader :code

    @@guesses = {}

    def initialize
        @@instance = self
        @code = []
        for num in 0...4
            color = Board.colors[rand(6)]
            @code.append(color)
        end
    end

    def self.instance
        return @@instance
    end

    def self.guesses
        return @@guesses
    end

    def self.hints(colors)
        hints = {}
        for i in 0...4
            color = colors[i]
            if colors[i] == Computer.instance.code[i] and colors.count(color) == 1
                hints[color] = 'black'
            elsif Computer.instance.code.include?(color) and colors.count(color) == 1
                hints[color] = 'white'
            elsif colors.count(color) > 1
                if Computer.instance.code.include?(color)
                    if colors[i] == Computer.instance.code[i]
                        if !hints[color]
                            hints[color] = ['black']
                        else
                            hints[color].append('black')
                        end
                    else
                        if !hints[color]
                            hints[color] = ['white']
                        else
                            hints[color].append('white')
                        end
                    end
                end
            end
        end

        for val in hints.values
            if val.is_a?(Array)
                color = hints.key(val)
                val.sort!
                while val.length > Computer.instance.code.count(color)
                    val.pop
                end
            end
        end

        hint_array = []
        for val in hints.values
            if val.is_a?(Array)
                for hint in val
                    hint_array.append(hint)
                end
            else
                hint_array.append(val)
            end
        end

        Board.add_hints(hint_array)
    end

    def self.code_breaker(hints = [])
        last_guess = Computer.guesses.keys.last
        guess = []
        guess_number = nil
        
        if hints != nil
            guessed_colors = Computer.guesses[last_guess][:guess]
            guess_number = Computer.guesses.keys.last + 1
            Computer.guesses[last_guess][:hints] = hints
        else
            guess_number = 1
        end

        if hints == nil
            for i in 0...4
                color = Board.colors[rand(6)]
                guess.append(color)
            end
        elsif hints.empty?
            guess = Computer.random_color(4, guessed_colors, nil, 0)
        else
            if hints.length == 1
                index = rand(4)
                color_kept = guessed_colors[index]
                excluding = []
                for color in guessed_colors
                    if color != color_kept
                        excluding.append(color)
                    end
                end

                guess = Computer.random_color(4, excluding, [color_kept], 1)

                if hints.include?('black')
                    guess[index] = color_kept

                else
                    if guess[index] == guessed_colors[index]
                        Computer.code_breaker(hints)
                        return true
                    end
                end

            elsif hints.length == 2
                first = rand(4)
                second = rand(4)
                while second == first
                    second = rand(4)
                end

                colors_kept = [guessed_colors[first], guessed_colors[second]]
                excluding = []
                for color in guessed_colors
                    if !colors_kept.include?(color)
                        excluding.append(color)
                    end
                end

                guess = Computer.random_color(4, excluding, colors_kept, 2)

                if !hints.include?('white')
                    guess[first] = guessed_colors[first]
                    guess[second] = guessed_colors[second]

                elsif !hints.include?('black')
                    if guess[first] == guessed_colors[first] or guess[second] == guessed_colors[second]
                        Computer.code_breaker(hints)
                        return true
                    end

                elsif hints.include?('white') and hints.include?('black')
                    matched = rand(2)
                    
                    if matched == 0
                        if guess[second] == guessed_colors[second] or !guess.include?(guessed_colors[second])
                            Computer.code_breaker(hints)
                            return true
                        end
                        guess[first] = guessed_colors[first]
                    else
                        if guess[first] == guessed_colors[first] or !guess.include?(guessed_colors[first])
                            Computer.code_breaker(hints)
                            return true
                        end
                        guess[second] = guessed_colors[second]
                    end
                end

            elsif hints.length == 3
                left_out = rand(4)
                indices = []

                for i in 0...4
                    if i != left_out
                        indices.append(i)
                    end
                end

                colors_kept = []
                for index in indices
                    colors_kept.append(guessed_colors[index])
                end

                excluding = [guessed_colors[left_out]]

                guess = Computer.random_color(4, excluding, colors_kept, 3)

                if !hints.include?('white')
                    for index in indices
                        guess[index] = guessed_colors[index]
                    end
                
                elsif !hints.include?('black')
                    if guess[indices[0]] == guessed_colors[indices[0]] or guess[indices[1]] == guessed_colors[indices[1]] or guess[indices[2]] == guessed_colors[indices[2]]
                        Computer.code_breaker(hints)
                        return true
                    end

                elsif hints.count('black') == 2
                    non_matched = rand(3)

                    if guess[indices[non_matched]] == guessed_colors[indices[non_matched]]
                        Computer.code_breaker(hints)
                        return true
                    end

                    for i in 0...indices.length
                        if i != non_matched
                            guess[indices[i]] = guessed_colors[indices[i]]
                        end
                    end

                elsif hints.count('white') == 2
                    matched = rand(3)
                    non_matched = []
                    for i in indices
                        if i != indices[matched]
                            non_matched.append(i)
                        end
                    end

                    if guess[non_matched[0]] == guessed_colors[non_matched[0]] or guess[non_matched[1]] == guessed_colors[non_matched[1]]
                        Computer.code_breaker(hints)
                        return true
                    end

                    guess[indices[matched]] = guessed_colors[indices[matched]]

                end

            else
                guess = guessed_colors.shuffle

                if hints.count('white') == 2
                    first = rand(4)
                    second = rand(4)

                    while second == first
                        second = rand(4)
                    end

                    guess[first] = guessed_colors[first]
                    guess[second] = guessed_colors[second]

                elsif hints.count('black') == 3
                    non_matched = rand(4)
                    
                    for i in 0...4
                        if i != non_matched
                            guess[i] = guessed_colors[i]
                        end
                    end
                    
                elsif hints.count('white') == 3
                    matched = rand(4)
                    non_matched = []
                    for i in 0...4
                        if i != matched
                            non_matched.append(i)
                        end
                    end

                    while guess[non_matched[0]] == guessed_colors[non_matched[0]] or guess[non_matched[1]] == guessed_colors[1] or guess[non_matched[2]] == guessed_colors[non_matched[2]]
                        guess = guessed_colors.shuffle
                    end
                    guess[matched] = guessed_colors[matched]

                elsif hints.count('black') == 4
                    puts "Whoohoo! I won!"
                    return true
                end
            end
        end
        
        if guess == guessed_colors
            Computer.code_breaker(hints)
        end

        Computer.guesses[guess_number] = {
            :guess => guess,
        }
        Board.add_colors(guess)
        Board.display_board

        if Board.game_over?

        else
            Player.prompt_hints
        end
    end

    def self.random_color(amt_of_colors = nil, excluding = nil, including = nil, amt_of_hints = nil)
        colors = []
        all = []

        if amt_of_hints
            init_length = 4 - amt_of_hints
        end

        for color in Board.colors
            all.append(color)
        end

        if excluding
            for color in excluding
                all.delete(color)
            end
        end

        if including
            for color in including
                all.delete(color)
            end
        end

        if amt_of_colors
            for i in 0...init_length
                color = all[rand(all.length)]
                colors.append(color)
            end
        else
            return all[rand(all.length)]
        end

        if including
            colors += including

            while colors.length < amt_of_colors
                colors += including
            end

            while colors.length > amt_of_colors
                colors.pop
            end
        end
        
        return colors
    end
end

comp = Computer.new

puts "Please enter your name: "
name = gets

choice = nil
prompt = "\nHello #{name}\nWould you rather be the codemaker or codebreaker? "
loop do
    puts prompt
    choice = gets.chomp

    if choice == 'codemaker' or choice == 'codebreaker'
        break
    else
        prompt = "I'm sorry, I didn't catch that. Please either type 'codemaker' or 'codebreaker'"
    end
end

player = Player.new(name, choice)

player.verify_role