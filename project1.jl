using HorizonSideRobots

function cross!(r::Robot)
    side=Nord
    num_steps=0;
    for i in 1:4 
       num_steps = cross_marker1!(r,num_steps,side)
        side = HorizonSide(mod(Int(side) + 2,4))
        num_steps=cross_market2!(r,num_steps,side)
        side = HorizonSide(mod(Int(side) + 1,4))
   end
end   

function cross_marker1!(r::Robot,num_steps::Integer,side::HorizonSide)
    while isborder(r,side)==false
        putmarker!(r)
        move!(r,side)
        num_steps+=1             
    end   
    putmarker!(r)
    return num_steps
end

function cross_market2!(r::Robot,num_steps::Integer,side::HorizonSide)
    while num_steps>0
        move!(r,side)
        num_steps-=1            
    end 
    return num_steps 
end            
        

    



