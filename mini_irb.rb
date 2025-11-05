 require 'pry'
require "readline"
puts "Welcome to MiniIRB! Type 'exit' to quit."

context = binding #store local varibles & scope
buffer = ""

def handle_custom(input,context)
	case input
	when "help"
		puts "Avaliable commands:"
		puts "exit - quit the console"
		puts "help -show this help message"
		puts "clear - clear screen"
		true
	when "clear"
		system("clear") || system("cls")
		true
	else
		false
	end
end

def code_complete?(code)
  begin
    RubyVM::InstructionSequence.compile(code)
    true
  rescue SyntaxError => e
    if e.message.include?("unexpected end-of-input") ||
       e.message.include?("unexpected keyword_end") ||
       e.message.include?("unterminated string")
      false
    else
      true
    end
  end
end

prompt = ">> "
buffer = ""

while input = Readline.readline(prompt, true)
  break if input.strip == "exit"
  next if handle_custom(input.strip, context)

  buffer << input + "\n"

  # Check if code is complete
  unless code_complete?(buffer)
    prompt = ".. "
    next
  end

  begin
    result = eval(buffer, context)
    puts "=> #{result.inspect}"
  rescue Exception => e
    puts "Error #{e.class} - #{e.message}"
  ensure
    buffer = ""
    prompt = ">> "
  end
end

