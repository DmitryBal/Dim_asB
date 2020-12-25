using HorizonSideRobots

function search_escape!(r::Robot)
    side=West
    while isborder(r,Nord)==true
        while isborder(r,side)==false
            move!(r,side)
            if isborder(r,Nord)==false
                break
            end
        end    
        side=HorizonSide(mod(Int(side) + 2,4)) 
    end   
end