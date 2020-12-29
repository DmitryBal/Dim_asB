using HorizonSideRobots

function rectangle!(r::Robot) #ax
    num_steps1=0
    num_steps2=0
    steps_Nord=0
    while isborder(r,Sud)==false
        move!(r,Sud)
        num_steps1+=1  
    end   
    while isborder(r,West)==false
        move!(r,West)
        num_steps2+=1
    end
    while isborder(r,Sud)==false
        move!(r,Sud)
        num_steps1+=1  
    end 
    while isborder(r,Nord)==false
         move!(r,Nord)
         steps_Nord+=1
     end
    steps_Nord=steps_Nord-2
    move!(r,Ost)
    if isborder(r,Sud)==false
       move!(r,Sud) 
       wall=false
    end
    if isborder(r,Sud)==true
        wall==true
    end  
    side=Sud
    while wall==false
            for i in 1:steps_Nord
                if isborder(r,side)==false && wall==false
                   move!(r,side) 
                end
                if isborder(r,side)==true
                    wall=true
                    break
                end
                i+=1
             end
             if wall==false
                if isborder(r,Ost)==false
                    move!(r,Ost)
                    side=HorizonSide(mod(Int(side) + 2,4))
                end  
                if isborder(r,Ost)==true
                    wall=true
                end
         end    
    end
            while isborder(r,Nord)==true || isborder(r,Sud)==true
                move!(r,Ost)
            end
            if side==Nord
                move!(r,Nord)
                while isborder(r,West)==true
                    move!(r,Nord)
                end
            end
        side=Sud
        side1=West
        move!(r,West)   
        for i in 1:4 
            while isborder(r,side)==true
                putmarker!(r)
                move!(r,side1)
            end
            putmarker!(r)
            move!(r,side)   
            side = HorizonSide(mod(Int(side) + 1,4))
            side1 = HorizonSide(mod(Int(side1) + 1,4))       
        end 
        move!(r,Ost)
        while isborder(r,Sud)==false
            move!(r,Sud)
        end   
        while isborder(r,West)==false
            move!(r,West)
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