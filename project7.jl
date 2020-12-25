using HorizonSideRobots

function chess!(r::Robot)
    counter_steps=0
    side=Nord
    num_steps1=0
    num_steps2=0
    while (isborder(r,Sud)==false && isborder(r,Ost)==false)
       move!(r,Sud)
       move!(r,Ost)
       num_steps1+=1
       num_steps2+=1
    end
    while isborder(r,Sud)==false
        move!(r,Sud)
        counter_steps+=1
        num_steps1+=1
    end
    while isborder(r,Ost)==false
        move!(r,Ost)
        counter_steps+=1
        num_steps2+=1
    end    
    while isborder(r,West)==false
        while isborder(r,side)==false
            if (mod(Int(counter_steps),2))==0
                putmarker!(r)
            end  
            counter_steps+=1
            move!(r,side)       
        end
        if isborder(r,West)==false
            if (mod(Int(counter_steps),2))==0
                putmarker!(r)
            end  
            move!(r,West)
            counter_steps+=1
        end
        side=HorizonSide(mod(Int(side) + 2,4)) 
    end
    if isborder(r,Sud)==true
        while isborder(r,Nord)==false
            if (mod(Int(counter_steps),2))==0
                putmarker!(r)
            end  
            counter_steps+=1
            move!(r,Nord)       
        end     
    end
     if (isborder(r,Nord)==true)
        while isborder(r,Sud)==false
            if (mod(Int(counter_steps),2))==0
                putmarker!(r)
            end  
            counter_steps+=1
            move!(r,Sud)       
        end        
    end
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    while isborder(r,Ost)==false
        move!(r,Ost)
    end
    while num_steps1>0
        move!(r,Nord)
        num_steps1-=1
    end
    while num_steps2>0
        move!(r,West)
        num_steps2-=1
    end   
end