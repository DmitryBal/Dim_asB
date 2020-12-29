using HorizonSideRobots

function temper!(r::Robot)::Real#s
    side=Nord
    result=0
    count=0
    while isborder(r,Ost)==false
        while isborder(r,side)==false
            if ismarker(r)
                result+=temperature(r)
                count+=1
            end    
            move!(r,side)    
        end
        if ismarker(r)
            result+=temperature(r)
            count+=1
        end    
        if isborder(r,Ost)==false
            move!(r,Ost)
        end
        side=HorizonSide(mod(Int(side) + 2,4)) 
    end
    if isborder(r,Sud)==true
        while isborder(r,Nord)==false
            if ismarker(r)
                result+=temperature(r)
                count+=1
            end   
            move!(r,Nord) 
        end   
    end 
    if isborder(r,Nord)==true
        while isborder(r,Sud)==false
            if ismarker(r)
                result+=temperature(r)
                count+=1
            end   
            move!(r,Sud) 
        end   
    end
    if ismarker(r)
        result+=temperature(r)
        count+=1
    end 
    result=result/count
    return result      
end