input_file = ARGV[0]
my_string = File.open(input_file).read



class InfixToPrefix

    # init the 2 array, reverse ( and ), transform string in array and reverse it
    def initialize(my_string)
        @array_output = []
        @operator_stack = []
        my_array = []
        my_string = my_string.gsub('(' , '@').gsub(')' , '(').gsub('@' , ')')
        my_array = my_string.split(" ")
        my_array = my_array.reverse
        perform(my_array)
    end

    # look for each elem if its an operator or a bracket
    def perform(my_array)
        my_array.each do |string|
            if operand_or_operator(string)
                operator_stack_gestion(string)
            elsif string == "("
                @operator_stack << string
            elsif string == ")"
                until @operator_stack.last == "("
                    @array_output << @operator_stack.pop
                end
                @operator_stack.pop
            else
                @array_output << string
            end
        end
        output_print
    end

    # def if operator or operand
    def operand_or_operator(string)
        if string == "+" || string == "-" || string == "*" || string == "/"
            return true
        end
    end

    # def priority
    def operator_priority(operator)
        if operator == "-" ||operator == "+"
            return 1
        elsif operator == '*' ||operator == '/'
            return 2
        else
            return -1
        end
    end

    def operator_stack_gestion(operator)
        if @operator_stack.empty?  || operator_priority(operator) > operator_priority(@operator_stack.last) || (@operator_stack.include?("("))
            @operator_stack << operator
        else
            while (!@operator_stack.empty?) && (operator_priority(operator) <= operator_priority(@operator_stack.last)) && @operator_stack.last != "("
                @array_output << @operator_stack.pop
            end
            @operator_stack.push operator
        end
    end

    # output with brackets and index for final output
    def output_print
        until @operator_stack.empty?
            @array_output << @operator_stack.pop
        end
        @array_output = @array_output.reverse
        final_array = []
        var = 0
        until @array_output.count == 1
            @array_output.each_with_index do |elem, index|
                next_elem = @array_output[index+1]
                next_next_elem = @array_output[index+2]
                if operand_or_operator(elem) && !operand_or_operator(next_elem) && !operand_or_operator(next_next_elem) && next_elem != nil
                    final_array << ['(', elem, next_elem, next_next_elem, ')']
                    2.times do 
                        @array_output.delete_at(index)
                    end
                    @array_output[index] = var
                    var += 1
                end
            end 
        end
        last_elem = final_array.last
        final_string = []
        replace_all(last_elem, final_array, final_string)
        
        puts final_string.join(" ")
    end

    def replace_all(last_elem, final_array, final_string)
        last_elem.each do |elem|
            if elem.class == Integer
                replace_all(final_array[elem], final_array, final_string)
            else
                final_string << elem
            end 
        end 
    end
end

def split_lines_and_go(my_string)
    if my_string.include? "\n"
        my_array = my_string.split("\n")
        my_array.each do |string|
            InfixToPrefix.new(string)
        end
    else
        InfixToPrefix.new(my_string)
    end
end

split_lines_and_go(my_string)