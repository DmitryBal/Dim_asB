using HorizonSideRobots

function search_marker!(r::Robot)
    find_marker=false
    while (isborder(r,Sud)==false && find_marker==false)
        if ismarker(r)
            find_marker=true
            break
        end 
        move!(r,Sud)   
    end
    while (isborder(r,West)==false && find_marker==false)
        if ismarker(r)
            find_marker=true
            break
        end    
        move!(r,West)
    end
    side=Nord
    while find_marker==false    
        while isborder(r,Ost)==false
            while isborder(r,side)==false
                if ismarker(r)
                    find_marker=true
                    break
                end 
                move!(r,side)      
            end
            if ismarker(r)
                find_marker=true
                break
            end 
            if isborder(r,Ost)==false            
                move!(r,Ost)
            end
            side=HorizonSide(mod(Int(side) + 2,4)) 
        end 
        if isborder(r,Sud)==true
            while isborder(r,Nord)==false
                if ismarker(r)
                    find_marker=true
                    break
                end 
                move!(r,Nord) 
            end   
        end 
        if isborder(r,Nord)==true
            while isborder(r,Sud)==false
                if ismarker(r)
                    find_marker=true
                    break
                end 
                move!(r,Sud) 
            end   
        end     
    end 
end