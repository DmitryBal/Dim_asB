using HorizonSideRobots

function perimetr_barriers!(r::Robot)
    count_west=0
    step_check=0
    wall=false
    n=0
    while wall==false
        while isborder(r,West)==false
            move!(r,West)
            count_west+=1
        end

        while isborder(r,Nord)==false
            move!(r,Nord)
            step_check+=1
        end
        
        if (isborder(r,Nord)==true && isborder(r,West)==true)
            wall=true
        end

        while step_check>0
            move!(r,Sud)
            step_check-=1
        end 
        side=West
        if wall==false
           count_west=cheking!(r,side,count_west,n)
        end    
    end
    count_nord=0
    while isborder(r,Nord)==false 
       move!(r,Nord)
       count_nord+=1 
    end 
    sideP=Sud
    putmarker!(r)
    move!(r,Sud)
    for i in 1:4 
        perimetr!(r,sideP)
        sideP = HorizonSide(mod(Int(sideP) + 1,4))   
    end       
    while count_nord>0
        move!(r,Sud)
        count_nord-=1
    end
    n=n+1
    while count_west>0
        while isborder(r,Ost)==false
            move!(r,Ost)
            count_west-=1
        end
        if count_west>0
            side=Ost
            count_west=cheking!(r,side,count_west,n)
        end
    end
end

function perimetr!(r::Robot,sideP::HorizonSide)
    while isborder(r,sideP)==false
        putmarker!(r)
        move!(r,sideP)
    end
end
function cheking!(r::Robot,side::HorizonSide,count_west::Integer,n::Integer)
    count_step_barrier=0   
    west_barrier=false 
 while isborder(r, side) == true
       move!(r,Nord)
       count_step_barrier+=1  
  end
move!(r,side)
if n==0
    count_west+=1 
    end
if n==1
    count_west-=1 
end
while (isborder(r,side)==false && isborder(r,Sud)==true)
 move!(r,side)
 if n==0
 count_west+=1 
 end
 if n==1
    count_west-=1 
 end
end
while count_step_barrier>0
   move!(r,Sud)
   count_step_barrier-=1
end 
return count_west   
end
            
     
