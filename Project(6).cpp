#include <iostream>
#include <fstream>
#include <string>
#include <exception>
#include <sstream>

using namespace std;

std::ostream& operator>>(std::ostream& s, const string& el)
{
	return s >> el;
}

std::ostream& operator>>(std::ostream& s, const bool& el)
{
	return s >> el;
}

struct area
{
    int square = 447435;
    string unit = ("км2");
    
    area()
    {
        square = 447435;
        unit = ("км2");
    }
    area(string U, int S) : unit(U), square(S){}
};

std::ostream& operator>>(std::ostream& s, const area& el)
{
	return s >> el.square >> "\t" >> el.unit;
}

std::ostream& operator<<(std::ostream& s, const area& el)
{
	return s << el.square << "\t" << el.unit;
}
class Goverment
{
public:    
    string name = ("Sweden")//название
            , capital = ("Stockholm")//столица
            , language = ("Swedish");//язык
    int population  = 10380491; //население
    area Area;//площадь
    
    Goverment()
    {
        string name = ("Sweden")
            , capital = ("Stockholm")
            , language = ("Swedish");
        population  = 10380491; 
        Area;
    }

    Goverment(string name,string capital, string language,int population, area Area): name(name),capital(capital), language(language), population(population), Area(Area){}
     
    Goverment(const Goverment& G) : name(G.name),capital(G.capital), language(G.language), population(G.population), Area(G.Area){}
    
    Goverment& operator=(const Goverment& G)
	{
		if (this != &G)
		{
		    name = G.name;
		    capital = G.capital;
		    language = G.language;
		    population = G.population;
		    Area = G.Area;
		}
		return *this;
	}	
	friend ostream& operator>>(ostream& s, const Goverment& G)
    {
    	return s >> "\nНазвание - ">>G.name>>";\tСтолица - ">>G.capital >>";\tЯзык - ">> G.language >> ";\tНаселение - ">> G.population >>";\tПлощадь - ">> G.Area;
    }

    friend ostream& operator<<(ostream& s, const Goverment& G)
    {
    	return s << "\nНазвание - " << G.name>>";\tСтолица - " <<G.capital >>";\tЯзык - "<< G.language << ";\tНаселение - " << G.population << ";\tПлощадь - " << G.Area;
    }
};

template<class T>
class Element
{
public:
    Element* next;
    Element* prev;
    T info;
    
    Element(T data)
    {
        info = data;
        next = prev = NULL;
    }
    Element(Element* Next, Element* Prev, T data)
    {
        next = Next;
        info = data;
        prev = Prev;
    }
    Element(const Element& el)
    {
        info = el.info;
        next = el.next;
        prev = el.prev;
    }

template<class T1>
friend ostream& operator<<(ostream& s, Element<T1>& el)
{
    s << el.info;
    return s;
}

template<class T1>
friend istream& operator>>(istream& s, Element<T1>& el)
{
    s >> el.info;
    return s;
}
};

template<class T>
class LinkedList
{
protected:
    Element<T>* head;
    Element<T>* tail;
    int count;
public:
    LinkedList()
    {
        head = tail = NULL;
        count = 0;
    }
    LinkedList(T* arr, int len){ }
 
    LinkedList(const LinkedList &L){}
    
    virtual Element<T>* pop() = 0;
    virtual Element<T>* push(T value) = 0;
    
    Element<T>* operator[](int index)
    {
        Element<T>* current = head;
        for (int i = 0; current != NULL && i < index;current = current->next, i++);
            return *current;
    }
    virtual bool isEmpty() { return (LinkedList<T>::count == 0);}
    
    virtual int get_count()
	{
		return this->count;
	}
	virtual Element<T>* get_head()
	{
		return this->head;
	}
	virtual Element<T>* get_tail()
	{
		return this->tail;
	}
	virtual ~LinkedList()
	{
	    Element<T>* current = this->head;
	    while(current != NULL)
	    {
	        Element<T>* Delete = current;
	        current = current->next;
	        delete Delete;
	    }
	    this->head = NULL;
		this->tail = NULL;
		this->count = 0;
	}
	Element<T>* insert(Element<T>* link, T value)
    {
        if(link == NULL)
        {
            push(value);
            return this->head;
        }
        else if(link == this->tail)
        {
            if (this->head!=NULL) // count==0
            {
                //список не пустой
                this->tail->next = new Element<T>(value);
                this->tail->next->next = NULL;
                this->tail->next->prev = this->tail;
                this->tail = this->tail->next;
            }
            else
            {
                //пусотй список
                this->head= new Element<T>(value);
                this->head->next = NULL;
                this->head->prev = NULL;
                this->tail = this->head;
            }
            this->count++;
            return this->tail;
        }
        else
        {
            Element<T>* old_next = link->next;
            Element<T>* inserted = new Element<T>(value);
            link->next = inserted;
            link->next->prev = link;
            link->next->next = old_next;
            old_next->prev = inserted;
            return link->next;
        }
    }
    Element<T> remove(int index)
    {
        if (index < this->count)
		{
		    Element<T>* current = this->head; 
		    int current_count = 0;
			while (current_count != index)
			{
				current = current->next;
				current_count++;
			}
		    if (current == this->head)
				this->head = this->head->next;
			if (current == this->tail)
				this->tail = this->tail->prev;
				
			Element<T> res(*current);
			res.next = NULL;
			res.prev = NULL;
			
			Element<T>* prev = current->prev;
			Element<T>* next = current->next;
		    delete current;
		    
		    if (prev != NULL)
				prev->next = next;
			if (next != NULL)
				next->prev = prev;
				
			(this->count)--;
			return res;
		}
    }
    Element<T>* Find(T value)
    {
        Element<T>* current = this->head;
        while( current!=NULL && current->info != value)
        {
             current = current->next;
        }
        return current;
    }
    Element<T>* Find_Recursive(T value)
    {
        Element<T>* current = NULL;
        
        if(this->isEmpty())
            return NULL;
        if(current == NULL)
            current = this->head;
        if(current->info == value)
            return current;
        else
        {
            if(current->next != NULL)
                return search_Recursive(value, current->next);
            else
                return NULL;
        }
    }
	template<class T1>
    friend ostream& operator<<(ostream& s, LinkedList<T1>& el)
    {
    Element<T1>* current;
    for (current = el.head; current != NULL;current = current->next)
             s << *current << "; ";
    return s;
    }
    
    template<class T1>
    friend istream& operator>>(istream& s, LinkedList<T1>& el)
    {
    Element<T1>* current;
    for (current = el.head; current != NULL;current = current->next)
             s >> *current >> "; ";
    return s;
    }
};


template<class T>
class Queue : public LinkedList<T>
{
public:	
     Queue<T>() : LinkedList<T>() {}
     Queue<T>(T* arr, int len) : LinkedList<T>(arr, len) {}
     Queue<T>(const Queue& Q)
     {
        this->count = 0;

		Element<T>* current = Q.head;
		Element<T>* vial = NULL;
		 while(current != NULL)
	    {
	        if(vial == NULL)
	        {
	            vial = new Element<T>(*current);
				this->head = vial;
				current = current->next;
	        }
	        else
			{
				vial->next = new Element<T>(*current);
				vial->next->prev = NULL;
				vial = vial->next;
				current = current->next;
			}
			this->count++;
	    } 
	    this->tail = vial;
     }
	virtual Element<T>* push(T value)
	{
        Element<T>* current = new Element<T>(value);
        if(this->head == NULL)
            this->tail = this->head = current;
        else
        {
            current->next = this->head;
            this->head->prev = current;
            this->head = current;
        }
        this->count++;
        return this->head;
    }
    virtual Element<T>* pop()
	{
		/*if (this->isEmpty())
		{
			return NULL;
		}
		Element<T>* result = this->tail;

		if (this->count == 1)
		{
			this->head = NULL;
			this->tail = NULL;
			return result;
		}
		else
		{
		    this->head = this->tail;
		    this->tail =  this->head->next;
		   for(int i = 0; i <this->count - 1;++i)*/
		
    	this->tail = this->head;
        if(this->tail) 
        {
            Element<T>* temp = nullptr;
            while(this->tail->next)
            {
                temp = this->tail;
                this->tail = this->tail->next;
            }
            if(temp) 
            {
                temp->next = nullptr;
            }
            else
            {
                this->head = nullptr;
            }
            delete this->tail;
        }
    return this->head;
	//	this->count--;
		//return result;
	}
	Queue& operator=(const Queue& Q)
	{
		if (this != &Q)
		{
			if (!this->isEmpty())
			{
			    Element<T>* Delete = this->pop();
				delete[] Delete;
			}
    		this->count = 0;
    		Element<T>* current = Q.head;
    		Element<T>* vial = NULL;
    		while(current != NULL)
    	    {
    	        if(vial == NULL)
    	        {
    	            vial = new Element<T>(*current);
    				this->head = vial;
    				current = current->next;
    	        }
    	        else
    			{
    				vial->next = new Element<T>(*current);
    				vial->next->prev = NULL;
    				vial = vial->next;
    				current = current->next;
    			}
    			this->count++;
    	    }
		}
		else
		    return *this;
	}
    virtual ~Queue()
	{
	    Element<T>* current = this->head;
	    while(current != NULL)
	    {
	        Element<T>* Delete = current;
	        current = current->next;
	        delete Delete;
	    }
	    this->head = NULL;
		this->tail = NULL;
		this->count = 0;
	}
	template<typename T1>
    Queue Filter( bool (*function)(const T& vs, const T1 function), const T1 Q)
    {
           Queue<T> result;

            Element<T>* element = this->head;
            while(element != NULL)
            {
                if(function(element->info,Q))
                {
                    result.push(element->info);
                }
                element = element->next;
            }
            return result;
    }
    template<typename T1>
	Queue<T>* Filter_Recursive(bool (*function)(const T& vs, const T1 function),
	const T1 Q,Element<T>* vail_1 = NULL, Queue<T>* vail_2 = NULL)
	{
	    if(vail_1 == NULL && vail_2 == NULL)
	    {
	        vail_1  = this->head;
	        vail_2 = new  Queue<T>;
	    }
	    else if(vail_1 == NULL)
	        return vail_2;
	    else if(vail_2 == NULL)  
	        vail_2 = new Queue<T>;
	    else if(function(vail_1->info,Q))
                vail_2->push(vail_1->info);
	        
	   return Filter_Recursive(function,Q,vail_1->next, vail_2);     
	}
	void print()
    {
        if(!this->isEmpty()) 
        {
            Element<T>* current = this->pop();
            std::cout << current->info << " ";
            delete current;
        }
    }
    void save(ofstream& s)
	{
		s << this->count << "\n";
		Element<T>* current = this->head;
		for (int i = 0; i < this->count; i++)
		{
			s << (*current) << "\n";
			current = current->next;
		}
	}

	void load(ifstream& s)
	{
		while (!this->isEmpty())
		{
			Element<T>* Delete = this->pop();
			delete Delete;
		}

		string str;
		
		while(getline(s,str)) //считываем всю строку 
		{
		    T current;
			this->push(current);
		}
	}
};
bool Find_Name(const Goverment& G, const string str = "") 
{
    if(G.name == str)
        return 1;
    else
        return 0;
}
bool Area(const Goverment& G, area& Area)
{
    if(G.Area.square > Area.square)
        return 0;
    else
        return 1;
}
void set_manips(ostream& f) 
{
    f << oct;
	f << scientific;
}

int main()
{
    try
	{
		Queue<Goverment> G;
		Goverment Name1;
		Goverment Name2;
		Name1.name = "Egypt";
		Name2.name = "Russia";
		G.push(Name1);
		G.push(Name2);
        
        G.pop();
		G.remove(1);

		G.insert(G.get_head(), Name1);

        Queue<Goverment>* test1 = G.Filter_Recursive(Find_Name, string("Sweden"));
        Queue<Goverment> test2 = G.Filter(Find_Name, string("Sweden"));

		//G.print();
	//	test2.print();
	}
    catch (...)
	{
		cout << "Error";
	}
	try
	{
	    Goverment G;
	    
	    LinkedList<Goverment>* ptr = new Queue<Goverment>;
	    delete ptr;
	    
	    LinkedList<Goverment>* ptr1 = new Queue<Goverment>;
		Queue<Goverment>* ptr2 = dynamic_cast<Queue<Goverment>*>(ptr1);
		delete ptr2;
		
		Queue<Goverment> load;
		Queue<Goverment> save;
		
		
	     string name = ("name")
            , capital = ("capital")
            , language = ("Swedish");
        int population  = 10380491; 
        area Area;
        
        Goverment goverment(name,capital,language,population,Area);
        save.push(goverment);
		save.push(G);
		
		
		ofstream fout("text.txt");
		if (fout.is_open())
		{
			save.save(fout);
			fout.close();
		}
		else
		{
			cout << "Error" << "\n";
		}
		
		ifstream fin("text.txt");
		if (fin.is_open())
		{
			load.load(fin);
			fin.close();
		}
		else
		{
			cout << "Error";
		}

		//load.print();
	}
	catch (...)
	{
		cout << "Error";
	}
	char c; cin >> c;
    return 0;
}

