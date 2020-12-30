using HorizonSideRobots

function field_barriers!(r::Robot)
    side=Ost
    mark_row(r,side)
    while isborder(r,side)==false
        move!(r,Nord)
        side=HorizonSide(mod(Int(side) + 2,4))  
        mark_row(r,side)
    end
end


function mark_row!(r::Robot,side::HorizonSide)
    putmarker!(r)
    while move_if_possible!(r,side) == true
        putmarker!(r)
    end
end

function move_if_possible!(r::Robot, main_side::HorizonSide)::Bool
    orthogonal_side = next(main_side)
    reverse_side = reverse(orthogonal_side)
    num_steps=0
    while isborder(r,main_side) == true
        if isborder(r, orthogonal_side) == false
            move(r, orthogonal_side)
            num_steps += 1
        else
            break
        end
    end
    if isborder(r,main_side) == false
        while isborder(r,reverse_side) == true
            move!(r,main_side)
        end
        result = true
    else
        result = false
    end
    move!(r,reverse_side)
    return result
end

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))