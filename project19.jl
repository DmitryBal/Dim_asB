using HorizonSideRobots

function findmarker_barriers!(r::Robot)
    marker=false
    while isborder(r,Sud)==false || isborder(r,West) == false
        if isborder(r,Sud)==false
           move!(r,Sud) 
           if ismarker(r)
                break
            end 
        end
        if isborder(r,West)==false
            move!(r,West) 
            if ismarker(r)
                break
            end 
         end
    end
    side=Nord
    step_check=0
    wall=false
    while !ismarker(r)
            while isborder(r,side)==false && !ismarker(r)          
                move!(r,side) 
            end

            while isborder(r,West)==false
                move!(r,West)
                step_check+=1
            end
            
            if (isborder(r,side)==true && isborder(r,West)==true)
                wall=true
            end
    
            while step_check>0
                move!(r,Ost)
                step_check-=1
            end 
            if wall==false && !ismarker(r)
               cheking!(r,side)
            end
            
             if wall==true && !ismarker(r)
                move!(r,Ost) 
                side=HorizonSide(mod(Int(side) + 2,4))
                wall=false 
             end          
    end
end

function cheking!(r::Robot,side::HorizonSide)
    count_step_barrier=0    
 while isborder(r, side) == true
       move!(r,West)
       count_step_barrier+=1  
  end
move!(r,side)
while (isborder(r,side)==false && isborder(r,Ost)==true)
 move!(r,side)
end
while count_step_barrier>0
   move!(r,Ost)
   count_step_barrier-=1
end   
end
            
     