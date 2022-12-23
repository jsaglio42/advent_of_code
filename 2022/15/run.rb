# frozen_string_literal: true

FILE_NAME = 'input.txt'

class Beacon < Struct.new(:x, :y)
  def position
    [x, y]
  end
end

class Sensor < Struct.new(:x, :y, :beacon)
  def position
    [x, y]
  end
  def radius
    manhattan_distance(position, beacon.position)
  end
end

SENSORS = []

File
  .read(FILE_NAME)
  .split("\n")
  .map do |line|
    line =~ /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

    SENSORS << Sensor.new($1.to_i, $2.to_i, Beacon.new($3.to_i, $4.to_i))
  end

BEACONS = SENSORS.map(&:beacon).uniq(&:position)

def manhattan_distance(src, dest)
  (src[0] - dest[0]).abs + (src[1] - dest[1]).abs
end

def radius(sensor)
  manhattan_distance(sensor.position, sensor.beacon.position)
end

def project_sensor(sensor, line)
  projected_radius = sensor.radius - (line - sensor.y).abs
  return [] if projected_radius < 0
  [sensor.x - projected_radius, sensor.x + projected_radius]
end

def split_segment(segment, breakpoint)
  return [segment] if breakpoint < segment[0] || breakpoint > segment[1]
  result = [[breakpoint, breakpoint]]
  result.push([segment[0], breakpoint - 1]) if segment[0] <= breakpoint - 1
  result.push([breakpoint + 1, segment[1]]) if breakpoint + 1 <= segment[1]
  result
end

def merge_segments(segments, breakpoint)
  segments.map { |segment| split_segment(segment, breakpoint) }.flatten(1).uniq
end

def impossible_places(line_no)
  projected_sensors = SENSORS.map { |sensor| project_sensor(sensor, line_no) }.reject(&:empty?)
  breakpoints = projected_sensors.flatten.uniq.sort

  merged_segments =
    breakpoints.reduce(projected_sensors.clone) { |acc, breakpoint| merge_segments(acc, breakpoint) }.sort

  merged_segments.map { |segment| segment[1] - segment[0] + 1 }.sum -
    SENSORS.select { |sensor| sensor.y == line_no }.count - BEACONS.select { |sensor| sensor.y == line_no }.count
end

# Answer 1
pp impossible_places(2_000_000)
