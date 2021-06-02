#include <iostream>
#include <cstring>


using namespace std;

class BaseString
{
protected:
	char* p;
	int len; // кол-во строк
	int capacity; // сколько выделино памяти 
public:
	BaseString(const char* ptr)
	{
		cout<<"\nBase Constructor 1\n";
		if (ptr != NULL)
		{
		    len = strlen(ptr) + 1;
			capacity =(256 > len )?  256 : len;
			p = new char[capacity];
			for (int i = 0; i < len; i++)
			{
				p[i] = ptr[i];
			}
			p[len] = '\0';
		}
	}

	BaseString(int Capacity = 256)
	{
		cout << "\nBase Constructor 0\n";
		capacity = Capacity;
		p = new char[capacity];
		len = 0;
	}

	~BaseString()
	{
		cout << "\nBase Destructor\n";
		if (p != NULL)
			delete[] p;
		len = 0;
	}

	int Length() { return len; }
	int Capacity() { return capacity; }
	char* get() {return p;}
	char& operator[](int i) { return p[i]; }


	BaseString& operator=(BaseString& s)
	{
		cout << "\nBase Operator = \n";

		if (capacity < s.len)
		{
			len = s.len;
			int i = 0;
			for (i = 0; i < len; i++)
				p[i] = s.p[i];
			p[i] = '\0';
		}
		return *this;
	}

	BaseString(BaseString& s)
	{
		cout << "\nBase Copy Constructor\n";
		if (s.p != NULL)
		{
			int i = 0;
			len = s.len;
			capacity = (256 > len) ? 256 : len;
			p = new char[capacity];
			for (int i = 0; i < s.len; i++)
			{
				p[i] = s[i];
			}
			p[i] = '\0';
		}
	}
	BaseString operator+(BaseString s)
	{
		int res_len = len + s.len + 1 > 256 ? len + s.len + 1 : 256;
		BaseString Res;
		int i;
		for (int i = 0; i < len; i++)
		{
			Res[i] = p[i];
		}
		for (int i = 0; i < s.len; i++)
		{
			Res[len + i] = s.p[i];
		}
		Res[len + s.len] = '\0';
		Res.len = len + s.len;
		return Res;
	}

	virtual void print()
	{
		int i = 0;
		while (p[i] != '\0')
		{
			cout << p[i];
			i++;
		}
	}
};



class ChildString : public BaseString
{
public:
	ChildString(ChildString& s)
	{
		cout << "\nDerived Copy Constructor\n";
		len = s.Length();
		p = new char[s.capacity];
		capacity = s.capacity;

		for (int i = 0; i < s.Length() - 1; i++)
		{
			p[i] = s[i];
		}
		p[len - 1] = '\0';
	}
	ChildString(const char* ptr):BaseString(ptr)
	{
		cout << "\nBase Constructor 1\n";
	}
	~ChildString()
	{
		cout << "\nChild Destructor\n";
	}
	ChildString& operator+(ChildString& s)
	{
		int len1 = len + s.Length() - 1;
		int l1 = len;
		int i = l1-1;

		while (s[i - l1] != '\0')
		{
			p[i] = s[i - l1+1];
			i++;
		}
		p[i] = '\0';
		len = len1;
		return *this;
	}
	ChildString& operator=(ChildString& s)
	{
		cout << "\nChild Operator = \n";
		BaseString &ret = (BaseString& )s;
		BaseString::operator=(ret);

		return *this;
	}
  int LastIndexOf(ChildString& str)
{
        bool flag = false;
		int i = 0, j = 0, index;

		while (j < str.Length() && i < len)
		{
			if (p[i] == str.p[j])
			{
				flag = true;
				if (p[i] == str.p[0])
					index = i;
				++j;
			}
			else
			{
				flag = false;
				j = 0;
				index = 0;
			}
			++i;
		}

		if (flag && j == str.Length())
		{
            return index;
		}
		else
		{
			return -1;
		}

	}
};


int main()
{
ChildString str("ddabcddabcd");
ChildString test("abcd");

int i = str.LastIndexOf(test);
 
	cout << i;
char c; cin>>c;
return 0;
}