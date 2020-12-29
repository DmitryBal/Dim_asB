using HorizonSideRobots

function perimetr_barriers!(r::Robot)#aa
    count=0
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
        side=Nord
        side_main=West
        if wall==false
           count_west=cheking!(r,side,side_main,count_west,n)
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
    putmarker!(r)
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
        side=Nord
        side_main=Ost
        count_west=cheking!(r,side,side_main,count_west,n)
    end

end

function perimetr!(r::Robot,sideP::HorizonSide)
    while isborder(r,sideP)==false
        putmarker!(r)
        move!(r,sideP)
    end
end
function cheking!(r::Robot,side::HorizonSide,side_main::HorizonSide,count_west::Integer,n::Integer)
    count_step_barrier=0    
    west_barrier=true
while isborder(r,side_main)==true
   while isborder(r,side)==false && west_barrier==true
       move!(r,side)
       count_step_barrier+=1
       if isborder(r,side_main)==false
           west_barrier=false
           break
       end
   end
   side=HorizonSide(mod(Int(side) + 2,4)) 
   if isborder(r,side_main)==true
       while count_step_barrier>0
           move!(r,side)
           count_step_barrier-=1
       end
   end    
end
move!(r,side_main)
if n==0
    count_west+=1 
    end
if n==1
    count_west-=1 
end
while (isborder(r,side_main)==false && isborder(r,side)==true)
 move!(r,side_main)
 if n==0
 count_west+=1 
 end
 if n==1
    count_west-=1 
 end
end
while count_step_barrier>0
   move!(r,side)
   count_step_barrier-=1
end 
return count_west   
end
        
     