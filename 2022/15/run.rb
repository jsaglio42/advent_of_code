# frozen_string_literal: true

FILE = 'input.txt'

def input_width(file)
  {
    'sample.txt' => 20,
    'input.txt' => 4_000_000,
  }[file]
end

def input_line_no(file)
  {
    'sample.txt' => 10,
    'input.txt' => 2_000_000,
  }[file]
end

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
  .read(FILE)
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
  return nil if projected_radius < 0
  (sensor.x - projected_radius..sensor.x + projected_radius)
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

# Just some pre-calculation
def beacon_or_sensor_count_by_line(width = 0)
  return @beacon_or_sensor_count_by_line[width] if @beacon_or_sensor_count_by_line&.key?(width)
  line_nos = BEACONS.map(&:y).uniq
  
  @beacon_or_sensor_count_by_line ||= {}
  @beacon_or_sensor_count_by_line[width] ||= line_nos.reduce(Hash.new { 0 }) do |acc, line_no|
    acc[line_no] = (BEACONS + SENSORS).reject { |node| node.y != line_no || ((width > 0) && (node.x < 0 || node.x > width)) }.count
    acc
  end
end

def ranges_overlap?(a, b)
  a.include?(b.begin) || b.include?(a.begin)
end

def merge_ranges(a, b)
  [a.begin, b.begin].min..[a.end, b.end].max
end

def truncate_range(range, min, max)
  [range.begin, min].max..[range.end, max].min
end


def merge_overlapping_ranges(ranges)
  ranges.sort_by(&:begin).inject([]) do |acc, range|
    if !acc.empty? && ranges_overlap?(acc.last, range)
      acc[0...-1] + [merge_ranges(acc.last, range)]
    else
      acc + [range]
    end
  end
end

def impossible_places(line_no, width = 0)
  projected_sensors = SENSORS.map { |sensor| project_sensor(sensor, line_no) }.reject!(&:nil?)

  if width > 0
    merge_overlapping_ranges(projected_sensors).map { |range| truncate_range(range, 0, width) } if width > 0
  else
    merge_overlapping_ranges(projected_sensors)
  end
end

def count_impossible_places(line_no, width = 0)
  impossible_places(line_no, width).reduce(0) { |acc, segment| acc + segment.last - segment.first + 1 }
end

# Answer 1
puts count_impossible_places(input_line_no(FILE)) - beacon_or_sensor_count_by_line[input_line_no(FILE)]

# Answer 2
distress_line = (0..input_width(FILE)).find_index do |line_no|
  puts("#{100.0 * line_no.to_f / input_width(FILE).to_f}%") if (line_no % 100_000) == 0
  count_impossible_places(line_no, input_width(FILE)) < (input_width(FILE) + 1)
end
distress_column = impossible_places(distress_line, input_width(FILE)).first.last + 1
pp(distress_line + (distress_column * 4_000_000))
