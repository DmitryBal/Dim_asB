#include <iostream>
#include <algorithm>


using namespace std;



//����� ����������� ����� - ������� ����; ��������� �� �������������� � ����������� �����(1.1)  
//����� ��������� �� ����������� ����� - ������������ ��������������� � ������������ �����(1.2)		



class Complex
{
protected:
	double Real; //������������ �����
	double Imaginary; //������ �����
public:
	//������������
	Complex() :Real(1), Imaginary(1) {  }; //�� ���������

	Complex(const Complex& complex) :Real(complex.Real), Imaginary(complex.Imaginary) {  }; //�����������

	Complex(const double& value1,const double& value2) :Real(value1), Imaginary(value2) {  };//�������


	~Complex() {  }//����������

	//����������
	void show(); //����� ������������ �����
	
	int get_im(); //������
	
	int get_re();//������

	void set_re(const double& re); //������

	void set_im(const double& re); //������

	Complex operator=(const Complex& value);

	Complex operator+();//������� ����

	Complex operator*(const Complex& value);//��������� �� �������������� � ����������� �����
};

Complex Complex::operator=(const Complex& value)
{
	if (this == &value)
	{
		return *this;
	}
	else
	{
    Complex Res;
	Res.Real = value.Real;
	Res.Imaginary = value.Imaginary;
	return Res;
	}
}

class Complex_1 : public Complex //���������
{
public:
		Complex_1(const double& value1, const double& value2)
		{
			Real = value1;
			Imaginary = value2;
			 
		};
		Complex_1()  
		{
			Real = 1;
			Imaginary = 1;
		};
		Complex_1(const Complex_1& complex) 
		{
			Real = complex.Real;
			Imaginary = complex.Imaginary;
		}
		
		Complex_1(Complex& complex)
		{
			Real = complex.get_re();
			Imaginary = complex.get_im();
		}

		Complex_1 operator=(Complex n)
		{
			if (this == &n)
			{
				return *this;
			}

			Real = n.get_re();
			Imaginary = n.get_im();

		}
		Complex_1 operator=(const Complex_1& x)
		{
			if (this == &x)
			{
				return *this;
			}

			Real = x.Real;
			Imaginary = x.Imaginary;
		}


		~Complex_1() {}

		friend Complex_1 operator*(double re, Complex value);
};

Complex_1 operator*(double re, Complex value)
{
	Complex_1 Res;
	Res.Real = re*value.get_re();
	Res.Imaginary = re*value.get_im();
	return Res;
}

void Complex::set_re(const double& re)
{
	Real = re;
}

void Complex::set_im(const double& re)
{
	Imaginary = re;
}

void Complex::show() //����� ������������ �����
{
	cout << "������������ ����� = " << Real << "\n������ ����� = " << Imaginary << endl;
}

int Complex::get_re()
{
	return Real;
}

int Complex::get_im()
{
	return Imaginary;
}

Complex Complex::operator+() //������� ����
{
	this->Real = Real;
	Complex Res;
	Res.Real = Real;
	if(Imaginary < 0)
		Res.Imaginary = (-1)*Imaginary;
	else
	    Res.Imaginary = Imaginary;
	return Res;
}


Complex Complex::operator*(const Complex& complex) //��������� �� �������������� � ����������� �����
{
	Complex Res;
	Res.Real = Real*complex.Real - Imaginary*complex.Imaginary;
	Res.Imaginary = Real*complex.Imaginary + Imaginary*complex.Real;
	return Res;
}

int main()
{
	setlocale(LC_ALL, "Ru-ru");
    Complex C1(-2, -3);
    Complex C2(3, 1);
    Complex C = C1*C2;
    Complex C3 = +C1;
    
	C.show();
	C3.show();
	return 0;
}