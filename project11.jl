using HorizonSideRobots

function four_markers!(r::Robot)
    side=Nord
    side1=West  
    for i in 1:4
        num_steps=0
        count=0
        count1=0
        if isborder(r,side)==false
            move!(r,side)
            putmarker!(r)
            side=HorizonSide(mod(Int(side) + 2,4))  
            move!(r,side)  
            side=HorizonSide(mod(Int(side) + 2,4))      
        end
        if isborder(r,side)==true
            while isborder(r,side)==true
                while isborder(r,side1)==false
                    move!(r,side1)
                    num_steps+=1
                    if isborder(r,side)==false
                        break
                    end
                end   
                side1=HorizonSide(mod(Int(side1) + 2,4)) 
                num_steps=num_steps-2*num_steps
            end
            move!(r,side)
            if (num_steps>0)
                side1=HorizonSide(mod(Int(side1) + 2,4))  
                while num_steps>0
                    move!(r,side1)
                    num_steps-=1
                    count+=1
                end 
                putmarker!(r)
                side1=HorizonSide(mod(Int(side1) + 2,4)) 
                while count>0
                    move!(r,side1)
                    count-=1
                    count1+=1
                end
                side1=HorizonSide(mod(Int(side1) + 1,4)) 
                move!(r,side1)
                side1=HorizonSide(mod(Int(side1) + 1,4)) 
                while count1>0
                    move!(r,side1)
                    count1-=1
                end
            end
            if num_steps<0 
                while num_steps<0
                    move!(r,side1)
                    num_steps+=1
                    count+=1
                end 
                putmarker!(r)
                side1=HorizonSide(mod(Int(side1) + 2,4)) 
                while count>0
                    move!(r,side1)
                    count-=1
                    count1+=1 
                end
                side1=HorizonSide(mod(Int(side1) - 1,4)) 
                move!(r,side1)
                side1=HorizonSide(mod(Int(side1) - 1,4)) 
                while  count1>0
                    move!(r,side1)
                    count1-=1
                end
                side1=HorizonSide(mod(Int(side1) + 2,4))         
            end   
        end
        side=HorizonSide(mod(Int(side) + 1,4)) 
        side1=HorizonSide(mod(Int(side1) + 1,4)) 
    end     
end
