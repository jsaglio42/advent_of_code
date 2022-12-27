# frozen_string_literal: true

class Room < Struct.new(:name, :rate, :dirty_neighbours, :neighbours)
  def initialize(...)
    super
    @opened = false
  end

  def open
    pp ">>> Open valve: #{name}(#{rate})" if $debug
    @opened = true
  end

  def opened?
    @opened
  end
end

def parse_file(file)
  File
    .read(file)
    .split("\n")
    .map do |line|
      line =~ /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/

      Room.new($1, $2.to_i, $3.split(',').map(&:strip), {})
    end
end

def distances_by_room(rooms_by_name, src)
  distances = {src => 0}
  parents = {}
  nodes_to_visit = [src]
  while nodes_to_visit.size > 0
    current = rooms_by_name[nodes_to_visit.shift]
    current.dirty_neighbours.each do |room|
      next if distances.key?(room)
      
      nodes_to_visit.push(room)
      distances[room] = distances[current.name] + 1
      parents[room] = current.name
    end
  end
  distances
end

file = 'input.txt'
rooms = parse_file(file)

rooms_by_name = rooms.reduce({}) { |acc, room| acc[room.name] = room ; acc }

# This is some preparation to only keep nodes with a rate > 0 and compute the distance between them
useful_rooms = rooms.select { |room| room.rate > 0} + [rooms_by_name["AA"]]
useful_rooms.map(&:name).each do |src|
  distances_by_room = distances_by_room(rooms_by_name, src)
  useful_rooms.map(&:name).each do |dst|
    next if src == dst || dst == "AA"

    rooms_by_name[src].neighbours[dst] = distances_by_room[dst]
  end
end

def current_rate(rooms)
  rooms.select(&:opened?).map(&:rate).sum
end

def closed_room(rooms)
  rooms.reject(&:opened?)
end

def room(rooms, name)
  rooms.find { |room| room.name == name }
end

def max_rate(rooms, room_name, remaining_time)
  current_room = room(rooms, room_name)
  current_rate = current_rate(rooms)

  if current_room.rate > 0 && !current_room.opened?
    current_room.open
    return current_rate + max_rate(rooms.map(&:clone), room_name, remaining_time - 1)
  end

  possibilities = {}
  current_room.neighbours.each do |dest_name, distance|
    next if room(rooms, dest_name).opened?
    next if remaining_time <= distance + 1

    possibilities[dest_name] = ((current_rate * distance) + max_rate(rooms.map(&:clone), dest_name, remaining_time - distance))
  end
  
  if possibilities.empty?
    current_rate * (remaining_time + 1)
  else
    maximum_rate = possibilities.values.max
    _, best_rate = possibilities.find { |_, v| maximum_rate == v}
    best_rate
  end
end

pp max_rate(useful_rooms, "AA", 29)