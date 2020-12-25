using HorizonSideRobots

function stair!(r::Robot)
    num_steps1=0
    num_steps2=0
    steps=0
    num_stepsN=-1
    while isborder(r,Sud)==false
        move!(r,Sud)
        num_steps1+=1  
    end   
    while isborder(r,West)==false
        move!(r,West)
        num_steps2+=1
    end 

    while isborder(r,Ost)==false
        putmarker!(r)
        move!(r,Ost)
        num_stepsN+=1
    end
    putmarker!(r)
    while (isborder(r,Nord)==false && num_stepsN>0)
            move!(r,Nord)
            move!(r,West)
            steps=row!(r,steps)
            putmarker!(r)
            while steps>0
                move!(r,Ost) 
                 steps-=1
             end
            num_stepsN-=1    
    end
    while isborder(r,Sud)==false
        move!(r,Sud)     
    end
    while num_steps2>0
        move!(r,Ost)
        num_steps2-=1
    end 
    while num_steps1>0
        move!(r,Nord)
        num_steps1-=1
    end    
 end

   


function row!(r::Robot,steps::Integer)
    while isborder(r,West)==false
        putmarker!(r)
        move!(r,West)
        steps+=1
    end
    return steps
end