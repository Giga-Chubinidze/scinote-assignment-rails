module LabHelper
  class Laboratory
    class WrongInputError < StandardError; end
  
    attr_reader :plate_size, :samples, :reagents, :replica_numbers
  
    def initialize(plate_size, samples, reagents, replica_numbers)
      @plate_size = plate_size
      @samples = samples
      @reagents = reagents
      @replica_numbers = replica_numbers
    end
    
    def call
      input_validation
      plates_generator
    rescue WrongInputError => e
      warn e
    end
  
    private
  
      def plates_generator
        mixtures = mixtures_generator()
        y_axis = 0
        x_axis = 0
        plate_array = []
        max_plate_height, max_plate_width = plate_dimensions_generator()
  
        plate = empty_plate_generator(max_plate_height, max_plate_width)
  
        mixtures.each do |mixture|
          plate[y_axis][x_axis] = mixture
  
          if y_axis == max_plate_height - 1 && x_axis == max_plate_width - 1 && mixture != mixtures.last
            y_axis = 0
            x_axis = 0
            plate_array.append(plate)
            plate = empty_plate_generator(max_plate_height, max_plate_width)
            next
          end
  
          if x_axis == max_plate_width - 1
            y_axis += 1
            x_axis = 0
          else
            x_axis += 1
          end
        end
  
        plate_array.append(plate)
        plate_array
      end
  
      def mixtures_generator
        result = []
        (0...samples.length).each do |i|
          replica_numbers[i].times do
            samples[i].each do |sample|
              reagents[i].each do |reagent|
                result.push([sample, reagent])
              end
            end
          end
        end
        mixtures_sorter(result)
      end
  
      def mixtures_sorter(mixtures)
        mixtures.sort_by { |mixture| [mixture.last, mixture.first] }
      end
  
      def plate_dimensions_generator
        plate_size == 96 ? [8, 12] : [16, 24]
      end
  
      def empty_plate_generator(max_plate_height, max_plate_width)
        Array.new(max_plate_height) { Array.new(max_plate_width) }
      end
  
      def input_validation
        unless plate_size == 96 || plate_size == 384
          raise WrongInputError, 'Plate size cant be that number, choose either 96 or 384!'
        end
  
        unless samples.length == reagents.length && reagents.length == replica_numbers.length
          raise WrongInputError, 'Please enter samples, reagents and replica number arrays of same length!'
        end
      end
  end
end
