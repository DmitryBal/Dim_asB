using HorizonSideRobots


function perimetr_markers!(r::Robot)
    num_steps1=0
    num_steps2=0
    while isborder(r,Nord)==false
        move!(r,Nord)
        num_steps1+=1  
    end
    
    while isborder(r,Ost)==false
        move!(r,Ost)
        num_steps2+=1
    end
    side=Sud
    putmarker!(r)
    move!(r,Sud)
    for i in 1:4 
        perimetr!(r,side)
        side = HorizonSide(mod(Int(side) - 1,4))   
    end    
    putmarker!(r) 
    while num_steps2>0
        move!(r,West)
        num_steps2-=1
    end 
    while num_steps1>0
        move!(r,Sud)
        num_steps1-=1
    end 
end
  
function perimetr!(r::Robot,side::HorizonSide)
    while isborder(r,side)==false
        putmarker!(r)
        move!(r,side)
    end
end

