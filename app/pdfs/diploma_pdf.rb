class DiplomaPdf
    include Prawn::View

    attr_accessor :contributor

    def initialize contributor, index
        @contributor = contributor
        @index = index
        content
    end

    def content
        stroke_bounds
        move_down 120
        text "PDF##{@index}", align: :center, size: 72
        move_down 60
        text "The award goes to", align: :center, size: 36
        move_down 60
        text "#{@contributor}", align: :center, size: 18
    end
end