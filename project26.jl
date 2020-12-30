using HorizonSideRobots

function Stripes!(r::Robot,num_passes::Integer, along_side::HorizonSide, across_side::HorizonSide,num_start_passes=0::Integer) 
    side = get_side(along_side,across_side)
    nun_steps = [get_num_movements!(r,side[i]) for i in 1:2]

    movements_if_posible!(r, along_side, num_start_passes) || return
    along_mark!(r,along_side)

    while movements_if_posible!(r,along_side, num_passes) == true
        along_side =HorizonSide(mod(Int(along_side) + 2,4))  
        along_mark!(r,along_side)
    end

    for k in start_side
        movements!(r,k)
    end


    back_side=HorizonSide(mod(Int(start_side) + 2,4))
    for (i,num) in arange(num_steps)
        movements!(r,back_side[i], num)
    end
end

function movements_if_posible!(r::Robot, side::HorizonSide, max_steps::Integer)
    for _ in 1:max_steps
        isborder(r,side) && (return false)
        move!(r,side)
    end
    return true
end

function along_mark!(robot::HorizonSide,side::HorizonSide)
    putmarker!(r)
    putmarkers!(r,side::HorizonSide)
end
