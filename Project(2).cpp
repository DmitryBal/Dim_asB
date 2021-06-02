#include <iostream>
#include <algorithm>
#include <cmath> 
 
using namespace std;
 
double Max(double n, double* ptr) // Поиск максимума.
{
    double M = ptr[0];
    for (int i = 0; i < n; i++) 
    {
        if (ptr[i] > M)
            M = ptr[i];
    }
    return M;
}
 
class MyArrayParent
{
protected:
 
    int capacity;
 
    int count;
 
    double* ptr;
public:
 
    MyArrayParent(int Dimension = 100)
    {
        cout << "\nMyArrayParent constructor";
        ptr = new double[Dimension];
        capacity = Dimension;
        count = 0;
    }
    ~MyArrayParent();
 
    int Capacity() { return capacity; }
    int Size() { return count; }
    double GetComponent(int index)
    {
        if (index >= 0 && index < count)
            return ptr[index];
        return -1;
    }
    void SetComponent(int index, double value)
    {
        if (index >= 0 && index < count)
            ptr[index] = value;
    }
 
    MyArrayParent(double* arr, int len);
 
    MyArrayParent(const MyArrayParent& V); // Конструктор копий.
 
    virtual void push(double value);
 
    void RemoveLastValue(); // Удаления элемента из произвольного места (с конца) в массиве.
 
    double& operator[](int index); // Оператор [ ] для обращения к элементу по индексу.
 
    MyArrayParent& operator=(const MyArrayParent& V); // Оператор =
 
    void print()
    {
        cout << "\nMyArrParent, size: " << count<<", values: {";
        int i = 0;
        for (i = 0; i < count; i++)
        {
            cout << ptr[i];
            if (i != count - 1)
                cout << ", ";
        }
        cout << "}";
    }
};
 
class MyArrayChild : public MyArrayParent
{
public:
 
    MyArrayChild(int Dimension = 100) : MyArrayParent(Dimension) { cout << "\nMyArrayChild constructor with Dimension"; } 
 
    ~MyArrayChild();
 
    void RemoveAt(int index);
 
    virtual int IndexOf(double value); // Поиск элемента в массиве по значению.
 
    void InsertAt(double value, int index); // Вставки элемента в некоторое место в массиве.
 
    MyArrayChild& operator=(const MyArrayChild& str);

    MyArrayChild SubSequence(int StartIndex, int Length);//Выделение подпоследовательности
 
  // int *SubSequence(int StartIndex, int Length); //Нахождение подпоследовательности
 
  // MyArrayChild GetSubSequence( int StartIndex, int Length); //Выделение подпоследовательности
 
    MyArrayChild Max_index(); // Получить индексы всех вхождений максимума в массив.
};
 
class MySortedArray : public MyArrayChild
{
protected:
 
    int BinaryFind(double value,int left, int right);
 
public:
    MySortedArray(int Dimension = 100) : MyArrayChild(Dimension) { cout << "\nMySortedArray constructor\n"; }
 
    ~MySortedArray();
 
    int IndexOf(double value);
 
    void push(double value);
 
    MySortedArray Max_index();
};
MyArrayParent::~MyArrayParent()
    {
        cout << "\nMyArrayParent destructor";
        if (ptr != NULL)
        {
            delete[] ptr;
            ptr = NULL;
        }
    }   
MyArrayParent::MyArrayParent(double* arr, int len)
    {
        cout << "\nMyArrayParent constructor";
        int capacity = len + 5;
        ptr = new double[capacity]; 
        int count = len;
 
    for (int i = 0; i < len; i++)
    {
        ptr[i] = arr[i];
    }
 
    print();
    }
MyArrayParent::MyArrayParent(const MyArrayParent& V)
{
    cout << "\nMyArrayParent constructor copy";
    capacity = V.capacity;
    count = V.count;
 
    ptr = new double[V.capacity];
    for (int i = 0; i < V.count; ++i)
        ptr[i] = V.ptr[i];
 
    print();
}
 
 
void MyArrayParent::push(double value)
{
    if (capacity > count)
    {
        ptr[count] = value;
        count++;
    }
    else
        cout << "Error" << endl;
}
 
void MyArrayParent::RemoveLastValue()
{
    if (count > 0)
        count -= 1;
}
 
double& MyArrayParent::operator[](int index)
{
    if (index < 0)
        return ptr[count + index];
    if (count > index)
        return ptr[index];
}
 
MyArrayParent& MyArrayParent::operator=(const MyArrayParent& V)
{
    if (this != &V)
    {
        capacity = V.capacity;
        count = V.count;
        delete[] ptr;
 
        ptr = new double[V.capacity];
        for (int i = 0; i < V.count; ++i)
            ptr[i] = V.ptr[i];
    }
    else
        return *this; 
}
MyArrayChild::~MyArrayChild()
    {
        cout << "\nMyArrayChild destructor\n";
        if (ptr != nullptr)
        {
            delete[] ptr;
            ptr = nullptr;
        }
    }
 
void MyArrayChild::RemoveAt(int index)
{
    if (abs(index) < count)
    {
        if (index > 0)
        {
            for (int i = index; i < count; i++)
            {
                ptr[i] = ptr[i + 1];
            }
            count--;
        }
        if (index < 0)
        {
            for (int i = count + index; i < count; i++)
            {
                ptr[i] = ptr[i + 1];
            }
        }
    }
}
int MyArrayChild::IndexOf(double value)
{
    for (int i = 0; i < count; i++)
        if (ptr[i] == value)
            return i;
    return -1;
}
 
void MyArrayChild::InsertAt(double value, int index)
{
    if (index > 0)
    {
        for (int i = count - 1; i >= index; i--)
        {
            ptr[i + 1] = ptr[i];
        }
        ptr[index] = value;
        count++;
    }
}
MyArrayChild& MyArrayChild::operator=(const MyArrayChild& V1)
{
    if (this != &V1)
    {
        count = V1.count;
        capacity = V1.capacity;
        delete[] ptr;
 
        ptr = new double[capacity];
        for (int i = 0; i < count; ++i)
        {
            ptr[i] = V1.ptr[i];
        }
    }
    else
        return *this;
}
 MyArrayChild MyArrayChild::SubSequence(int StartIndex, int Length)
 {
    MyArrayChild S;
    while(Length < 0)
    {
        Length +=count;
    }
    while(Length > count)
    {
        Length-=count;
    }
    while(StartIndex<0)
    {
        StartIndex+=count;
    }
    while(StartIndex>count)
    {
        StartIndex-=count;
    }
    for(int i = StartIndex;i<StartIndex + Length;i++)
    {
        if(i < count)
            S.push(ptr[i]);
        else
            break;
    }
    return S;
 }
/*int* MyArrayChild::SubSequence(int StartIndex, int Length)
{
    for(int i = 1; i< count; i++)
    {
        if (ptr[StartIndex] == ptr[StartIndex + i])
        {
            StartIndex+=i;
            break;
        }
    }
    for(int i =0;i < count - StartIndex;i++)
    {
        if(ptr[i] == ptr[StartIndex + i])
            Length++;
        else
            break;
    }

    int* det = new int[2];
    det[0] = StartIndex;
    det[1] = Length;
    return det;
}
MyArrayChild MyArrayChild::GetSubSequence(int StartIndex, int Length)
{
    MyArrayChild S; 
    
    int* indexes = new int[2];
    indexes = SubSequence(StartIndex, Length);
    
    for(int i = 0; i < indexes[1]/2; i++)
    {
        S.push(ptr[indexes[0] + i]);
    }
    return S;
}*/
 
MyArrayChild MyArrayChild::Max_index()
{
    MyArrayChild M; 
 
    M.count = count;
    M.capacity = capacity;
 
    int j = 0;
    for (int i = 0; i < count; i++) 
    {
        if (ptr[i] == Max(count,ptr))
        {
            M.ptr[j] = i;
            j++;
        }
        else
            M.count--;
    }
    return M;
}
 
MySortedArray::~MySortedArray()
    {
        if (ptr != NULL)
        {
            delete[] ptr;  
            ptr = NULL;
        }
        cout << "\nMySortedArray destructor\n";
    }
 
int  MySortedArray::BinaryFind(double value,int left, int right)
    {
        int middle = (left + right)/2;
        double eps = 0.0001;
 
        if(right == left + 1)
            {
                if(fabs(ptr[left] - value) < eps)
                    return left;
                if(fabs(ptr[right] - value) < eps)
                    return right;
            }
        if(fabs(ptr[middle] - value) < eps)
            return middle;
        if(ptr[middle] > value)
            return BinaryFind(value, left, middle);
        else
            return BinaryFind(value, middle, right);
    }
 
int MySortedArray::IndexOf(double value)
    {
        if(count == 0)
            return -1;
        else
            return BinaryFind(value, 0, count);
    }
 
void MySortedArray::push(double value)
    {
        if(count == 0)
            MyArrayParent::push(value);
            return;
        if(count == 1)
        {
            if(ptr[0] > value)
                InsertAt(value,0);
        else
            MyArrayParent::push(value);
        return;
        }
        int index = BinaryFind(value,0,count);
        InsertAt(value,index);
    }
 
MySortedArray MySortedArray::Max_index()
{
    MySortedArray M; 
 
    M.count = 0;
    M.capacity = capacity;
 
    int i = 1;
    int j =0;
    while (ptr[count - i] == ptr[count-1])
        {
             M.count++;
             M.ptr[j] = i;
             i++;
        }
   
    return M;
}
 
int main()
{
    MyArrayChild* p;
    if (true)
    {
        MyArrayChild arr;
        p=&arr;
        for (int i = 0; i < 10; i++)
        {
            arr.push(i + 1);
        }
        arr.print();
 
        MyArrayChild test, max_index;
        for (int i = 0; i < 10; i++)
        {
            test.push(i+1);
        }
        test.print();
        MyArrayChild getSub;
        getSub = test.SubSequence(3,5);
        getSub.print();
        
       /* int* det = new int[2];
        det = test.SubSequence(0,0);
        if(det[0] != 0)
        {
            cout <<  "\nStartIndex = " << det[0];
            cout<< "\nLength = " <<  det[1] << endl;
            
            MyArrayChild getSub;
            getSub = test.GetSubSequence(det[0],det[1]);
            getSub.print();
        }
        else
        {
           cout << "\nThere is no Subsequence in massiv" << endl;
        }*/
        
        int index = p->IndexOf(5);
        test.InsertAt(5, 5);
        cout << "\n\nIndex = " << index;
        
        test.print();
        max_index = test.Max_index();
        
        
        max_index.print();
        test.print();
    }
    char c; cin >> c;
    return 0;
}