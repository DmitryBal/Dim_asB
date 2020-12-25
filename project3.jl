using HorizonSideRobots

function field!(r::Robot)
    num_steps1=0
    num_steps2=0
    while isborder(r,Sud)==false
        move!(r,Sud)
        num_steps1+=1  
    end   
    while isborder(r,West)==false
        move!(r,West)
        num_steps2+=1
    end
    side=Nord
    while isborder(r,Ost)==false
        while isborder(r,side)==false
            putmarker!(r)
            move!(r,side)    
        end
        if isborder(r,Ost)==false
            putmarker!(r)
            move!(r,Ost)
        end
        side=HorizonSide(mod(Int(side) + 2,4)) 
    end
    if isborder(r,Sud)==true
        while isborder(r,Nord)==false
            putmarker!(r)
            move!(r,Nord) 
        end   
    end 
    if isborder(r,Nord)==true
        while isborder(r,Sud)==false
            putmarker!(r)
            move!(r,Sud) 
        end   
    end 
    putmarker!(r)
    while isborder(r,West)==false
        move!(r,West)
    end
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    while num_steps1>0
        move!(r,Nord)
        num_steps1-=1
    end
    while num_steps2>0
        move!(r,Ost)
        num_steps2-=1
    end   
end
