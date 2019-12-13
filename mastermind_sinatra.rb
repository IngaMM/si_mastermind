require "sinatra"
require "erb"
#require 'sinatra/reloader'

@@counter = 0;
@@guess = Array.new(12) { |i| i = ["white","white","white","white"] };
@@feedback_bc = Array.new(12) { |i| i = ["white","white","white","white"] };
@@feedback_bs = Array.new(12) { |i| i = ["none","none","none","none"] };
@@secret_code = [];
@@win = false

get '/' do
  erb :mainpage
end

get '/restart' do
  erb :mainpage
end

post '/restart' do
  @@counter = 0;
  @@guess = Array.new(12) { |i| i = ["white","white","white","white"] };
  @@feedback_bc = Array.new(12) { |i| i = ["white","white","white","white"] };
  @@feedback_bs = Array.new(12) { |i| i = ["none","none","none","none"] };
  @@secret_code = [];
  @@win = false
  erb :mainpage
end

post '/' do
  if @@counter == 0
    @@secret_code = chose_secret_code
  end

  @@counter += 1
  (0..3).each do |i|
    position = "pos" << (i+1).to_s
    @@guess[@@counter-1][i] = params[position]
  end
  evaluate_guess
  check_win

  if @@win == true
    @message = "The secret code has been found! Congratulations!"
  end

  if @@counter == 12
    @message = "Game over. The secret code was not found."
  end

  erb :mainpage

end

def chose_secret_code
  choice = []
  colors = ["yellow", "orange", "red", "magenta", "blue", "green"]
  i = 0
  while i < 4 do
      color = rand(colors.length)
      choice[i] = colors[color]
      i += 1
  end
  return choice
end

def evaluate_guess
  choice = @@guess[@@counter-1]
  secret_code_temp = []
  secret_code_temp.replace(@@secret_code)

  i = 0
  j = 0

  while i < choice.length do #find items with correct position & color
    if choice[i] == @@secret_code[i]
        @@feedback_bc[@@counter-1][i] = "black"
        secret_code_temp.delete_at(j)
        j -=1
    end
    i += 1
    j += 1
  end

  i = 0

  while i < @@feedback_bc[@@counter-1].length do #find items with correct color but wrong position
    if @@feedback_bc[@@counter-1][i] != "black" && secret_code_temp.include?(choice[i])
      @@feedback_bs[@@counter-1][i] = "solid"
      secret_code_temp.delete_at(secret_code_temp.index(choice[i]))
    end
      i += 1
  end
end

def check_win
  if @@feedback_bc[@@counter-1] == ["black", "black", "black", "black"]
    @@win = true
  end
end
