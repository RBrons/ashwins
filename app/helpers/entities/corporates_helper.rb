module Entities::CorporatesHelper
    def decimal_places(decimal)
        place = 0
        while(decimal != decimal.to_i)
            place += 1
            decimal *= 10
        end
        place
    end
end
