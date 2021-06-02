#include <iostream>

using namespace std;

/*
Вариант 1           
					      A1
				        /	 \
			           /	  \
			          /	       \
			         B1  	  	B2
					  \        /
					   \      /
					    \    /
						  C1
*/
class A1
	{
	protected:
		int a1;
	public:
		A1(int V1) : a1(V1) {};
		A1() : a1() {};
		virtual void print() { cout << "\nVariable of A1 class"; }
		virtual void show() { cout << "\nA1 = " << a1; }
	};
class B1: virtual public A1
	{
	protected:
		int b1;
	public:
		B1(int V1, int V2) : b1(V1),A1(V2) {};
		void print() { cout << "\nVariable of B1 class"; }
		void show() { cout << "\nA1 = " << a1<<", B1 = "<<b1; }
	};
class B2 : virtual public A1
	{
	protected:
		int b2;
	public:
		 B2(int V1, int V2) : b2(V1),A1(V2) {};
		void print() { cout << "\nVariable of B2 class"; }
		void show() { cout << "\nA1 = " << a1 << ", B2 = " << b2; }
	};
class C1 : public B1, public B2
	{
	protected:
		int c1;
	public:
		C1(int V1, int V2, int V3) : c1(V1),B1(V1,V2),B2(V3,V2) {};
		void print() { cout << "\nVariable of C1 class"; }
		void show() { cout << "\n\tA1 = " << a1 << "\nB2 = " << b2 << "\tB1 = " << b1 << "\n\tC1 = " << c1; }
	};
int main()
{
	B1 b1(1,2);
	b1.print();
	b1.show();

	C1 c1(3,2,1);
	c1.print();
	c1.show();

	B1* b2 = &c1;
	b2->print();
	b2->show();

	char c; std::cin>>c;
	return 0;

}