using HorizonSideRobots

function nxn_square!(r::Robot,n::Integer)
    num_steps1=0
    num_steps2=0 
    size_square=n
    counter_steps_mark=0
    counter_steps=0
    row=0 
    while isborder(r,Nord)==false
        move!(r,Nord)
        num_steps1+=1
    end

    while isborder(r,Ost)==false
        move!(r,Ost)
        num_steps2+=1
    end

    Nord_steps=1
    while isborder(r,Sud)==false
        move!(r,Sud)
        Nord_steps+=1
    end

    West_steps=0
    Ost_steps=0
    while isborder(r,West)==false
        move!(r,West)
        West_steps+=1
        Ost_steps+=1
    end

    while Nord_steps>1
        while row<n
            while isborder(r,Ost)==false
                for i in 1:n
                    putmarker!(r)
                    if isborder(r,Ost)==false
                        move!(r,Ost)
                    end   
                end
                for i in 1:n
                    if isborder(r,Ost)==false
                        move!(r,Ost)
                    end   
                end   
            end
            while West_steps>0
                move!(r,West)
                West_steps-=1          
            end
            if isborder(r,Nord)==false
                move!(r,Nord)
                Nord_steps-=1
                West_steps=Ost_steps
            end
           row+=1     
        end
        if (mod(Int(counter_steps),2))==0
            for i in 1:n
                if(isborder(r,Ost)==false) 
                    move!(r,Ost)
                end               
            end
            Ost_steps-=n 
            West_steps=Ost_steps
        end
        if (mod(Int(counter_steps),2))==1
            while isborder(r,West)==false
                move!(r,West)
                Ost_steps+=1
            end               
            West_steps=Ost_steps 
        end 
        row=0 
        counter_steps+=1               
    end
    while isborder(r,Ost)==false
        move!(r,Ost)
    end
    while num_steps2>0
        move!(r,West)
        num_steps2-=1
    end 
    while num_steps1>0
        move!(r,Sud)
        num_steps1-=1
    end 

end  
