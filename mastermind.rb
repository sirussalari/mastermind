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

class Player
    attr_reader :name
    
    def initialize(name)
        @@instance = self
        @name = name
    end

    def self.instance
        return @@instance
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

        Board.add_colors(color_choices)
        Computer.hints(color_choices)
    end
end

class Computer
    attr_reader :code

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

end

comp = Computer.new

puts "Please enter your name: "
name = gets
player = Player.new(name)
player.choose_colors