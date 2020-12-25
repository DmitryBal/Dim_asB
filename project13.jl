using HorizonSideRobots

function slant_cross!(r::Robot)
    side1=Nord
    side2=Ost
    num_steps=0
    for i in 1:4 
       num_steps = cross_marker1!(r,num_steps,side1,side2)
        side1 = HorizonSide(mod(Int(side1) + 2,4))
        side2 =  HorizonSide(mod(Int(side2) + 2,4))
        num_steps=cross_market2!(r,num_steps,side1,side2)
        side1 = HorizonSide(mod(Int(side1) - 1,4))
        side2 = HorizonSide(mod(Int(side1) - 1,4))
   end
end   

function cross_marker1!(r::Robot,num_steps::Integer,side1::HorizonSide,side2::HorizonSide)
    while (isborder(r,side1)==false && isborder(r,side2)==false)
        putmarker!(r)
        move!(r,side1)
        move!(r,side2)
        num_steps+=1             
    end   
    putmarker!(r)
    return num_steps
end

function cross_market2!(r::Robot,num_steps::Integer,side1::HorizonSide,side2::HorizonSide)
    while num_steps>0
        move!(r,side1)
        move!(r,side2)
        num_steps-=1            
    end 
    return num_steps 
end      