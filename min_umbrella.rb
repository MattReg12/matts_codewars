=begin
A Man and his Umbrellas
Each morning a man walks to work, and each afternoon he walks back home.

If it is raining in the morning and he has an umbrella at home, he takes an umbrella for the journey so he doesn't get wet, and stores it at work. Likewise, if it is raining in the afternoon and he has an umbrella at work, he takes an umbrella for the journey home.

Given an array of the weather conditions, your task is to work out the minimum number of umbrellas he needs to start with in order that he never gets wet. He can start with some umbrellas at home and some at work, but the output is a single integer, the minimum total number.

The input is an array/list of consecutive half-day weather forecasts. So, e.g. the first value is the 1st day's morning weather and the second value is the 1st day's afternoon weather. The options are:

"clear",
"sunny",
"cloudy",
"rainy",
"overcast",
"windy"
"thunderstorms".
e.g. for three days, 6 values:

weather = ["rainy", "cloudy", "sunny", "sunny", "cloudy", "thunderstorms"]
N.B. He never takes an umbrella if it is not raining.

Examples:
minUmbrellas(["rainy", "clear", "rainy", "cloudy"])
should return 2

Because on the first morning, he needs an umbrella to take, and he leaves it at work. So on the second morning, he needs a second umbrella.

minUmbrellas(["sunny", "windy", "sunny", "clear"])
should return 0

Because it doesn't rain at all

minUmbrellas(["rainy", "rainy", "rainy", "rainy", "thunderstorms", "rainy"])
should return 1

Because he only needs 1 umbrella which he takes on every journey.
=end

=begin

input: array of strings

output: integer

explicit: count the number of umbrellas that a man needs when going to and from work.
if its raining in the morning, he takes the umbrella to work.
if its raining in the afternoon, he takes the umbrella home
if its clear in the afternoon, he leaves the umbrella at work
if its clear in the morning, he leave the umbrella at home
he never takes an umbrella if its not rainy or thunderstorms


implicit:

data struc. array


algorithm:
initialize an int to count the umbrellas
initialize a variable to track the mans location
initialize a 2 element array for the locations as booleans indicating whether an umbrella is there

iterate through the argument
man moves to different location.
else not rainy: move man
if rainy and no umbrella: increment count, move man, mark location as containing umbrella
if rainy and umbrella, move man, mark location as containg an umbrella

=end

x = ["rainy", "rainy", "rainy", "rainy"] # 1
y = ["overcast", "rainy", "clear", "thunderstorms"] # 2

def min_umbrellas(weather)
  mans_location = 0
  umbrella_locations = [0, 0]
  weather.each do |forecast|
    if ["rainy", "thunderstorms"].include?(forecast)
      if umbrella_locations[mans_location].zero?
        mans_location = move_man(mans_location, umbrella_locations)
        umbrella_locations[mans_location] += 1
      else
        umbrella_locations[mans_location] -= 1
        mans_location = move_man(mans_location, umbrella_locations)
        umbrella_locations[mans_location] += 1
      end
    else
      mans_location = move_man(mans_location, umbrella_locations)
    end
  end
  umbrella_locations.sum
end


def move_man(mans_location, umbrella_locations)
  mans_location == 0 ? 1 : 0
end

p min_umbrellas(y)