class LabController < ApplicationController
  include LabHelper
  
  def index
    plate_size = 96
    sample_names = [['A1', 'B2', 'C3'], ['D1', 'E2', 'F3'], ['G1', 'H2', 'I3', 'J4'], ['K1', 'L2']]
    reagent_names = [['pink'], ['lime'], ['aquamarine'], ['orange']]
    replica_numbers = [7, 9, 10, 14]
    
    laboratory = Laboratory.new(plate_size, sample_names, reagent_names, replica_numbers)
    
    @plates = laboratory.call
    @width = @plates[0][0].length 
    @height = @plates[0].length
  end
end
