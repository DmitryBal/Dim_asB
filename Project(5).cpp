#include <iostream>
#include <cstring>
#include <fstream>
#include <exception>
#include <string>
#include <typeinfo>
#include <iomanip>

using namespace std;

/* Вариант 1(В наличии прямоугольная плоская решётка с шагом 1 В узлах
   решётки находятся точечные массы, хранящиеся в заданной
   матрице M. Вычислить координаты центра масс решётки.)
//------------------Наследование класса ошибок-------------------//
/
				std::exception
					 ^
					 |
					 |
					 |
 				     Exception
 				    ^        ^
				   /          \
				  /            \
				 /              \
			IndexOutOfBounds        WrongDimensionsException
		 	Exception                         ^
											  |
			  								  |
			 			                      |
						               WrongSizeException
*/

class Exception: public exception
{
protected:
	//сообщение об ошибке
    string error;
public:
	Exception(string& str)
	{
		error = str;
	}
	Exception(const char* s)
	{
		error = string(s);
	}
	Exception(const Exception& e)
	{
		this->error = e.error;
	}
	virtual ~Exception(){};
	
	virtual void print()
	{
		cout << "Exception: " << error << "; "<<what();
	}
};

class IndexOutOfBoundsException:  public  Exception
{
protected:
	int row_index;
	int col_index;
public:
	IndexOutOfBoundsException(string str, int row, int column) : Exception(str)
	{
		row_index = row;
		col_index = column;
	}
	virtual void print()
	{
		cout << "Exception: " << error << "row_index = " << row_index;
		cout << "col_index = " << col_index << ";" << what();
	}
};

class WrongDimensionsException :  public  Exception
{
protected:
	int R1, C1,R2, C2;
public:
	WrongDimensionsException(string str, int r1, int c1, int r2, int c2) : Exception(str), R1(r1), C1(c1), R2(r2), C2(c2) {}

	virtual void print() 
	{
	   cout << error << "\nОперации с данными размерами матриц: M1( "<< R1<< " \t " << C1 << " ) и M2(" << R2 << " \t " << C2 << " ) невозможны\endl";
	}
};
class WrongSizeException :  public Exception
{
protected:
	int row_index;
	int col_index;
public:
	WrongSizeException(string str, int r, int c) : Exception(str), row_index(r), col_index(c) { }

	virtual void print() 
	{
		cout << error << "\nВы ввели неккоректные размеры матрицы : ( " << row_index<< " , " << col_index<< ")\n";
	}
};
class IncorrectDataInMatrix :  public Exception
{
private:
	int r, c;
public:
	IncorrectDataInMatrix(string str, int row, int col) : Exception(str), r(row), c(col) {}

	virtual void print() 
	{
		cout << error << "\nВы ввели неккоректные данные в матрицу, элемент: << " << r << " , " << c << " >\n";
	}
};



template <class T>
class BaseMatrix
{
protected:
	T** ptr;
	int height;
	int width;

public:
	BaseMatrix(int H = 2, int W = 2) :  height(H), width(W)
	{
		if(height <= 0 || width <= 0)
		{
		throw WrongSizeException("\tОшибка в размерах матрицы",height, width);
		}
		height = H;
		width = W;
		ptr = new T* [height];
		for (int i = 0; i < height; i++)
			ptr[i] = new T[width];
	}
	BaseMatrix(const BaseMatrix& M)
	{
		//конструктор копий
		height = M.height;
		width = M.width;
		
		ptr = new T* [height];
		for (int i = 0; i < height; i++)
			ptr[i] = new T[width];

		for (int i = 0; i < height; i++)
			for (int j = 0; j < width; j++)
				ptr[i][j] = M.ptr[i][j];
	}
	virtual ~BaseMatrix()
	{
		//деструктор
		if (ptr != NULL)
		{
			for (int i = 0; i < height; i++)
				delete[] ptr[i];
			delete[] ptr;
			ptr = NULL;
		}
	}
	BaseMatrix& operator=(const BaseMatrix& M)
	{
		if (this != &M)
		{
			if (ptr != nullptr)
			{
				for (int i = 0; i < height; ++i)
					delete[] ptr[i];
				delete[] ptr;
			}

			height = M.height;
	    	width = M.width;

		    ptr = new T* [height];
    		for (int i = 0; i < height; i++)
    			ptr[i] = new T[width];
    			
		    for (int i = 0; i < height; i++)
		    	for (int j = 0; j < width; j++)
				    ptr[i][j] = M.ptr[i][j];
		}
		else
		{
			return *this;
		}
	}
	virtual T& operator() (int row, int column)
	{
	    if (row < 0 || column < 0 || row > height || column > width)
	        throw IndexOutOfBoundsException("Ошибка в обращении по индексу:", row, column);
		return ptr[row][column];
	}
	virtual	void print()
	{
		//вывод
		for (int i = 0; i < height; i++)
			for (int j = 0; j < width; j++)
				cout << ptr[i][j] << " ";
			cout << "\n";
	}
};


template<typename T1>
class Matrix : public BaseMatrix<T1>
{
protected:
	T1 ScalarProduct(T1* arr1, T1* arr2, int dim)
	{
		T1 sum = 0;
		for (int i = 0; i < dim; i++) {
			sum += arr1[i] * arr2[i];
		}
		return sum;
	}
public:
    Matrix(int H = 2, int W = 2) : BaseMatrix<T1>(H, W) {}
    Matrix(const Matrix& M)
	{
		//конструктор копий
		this->height = M.height;
		this->width = M.width;
		this->ptr = new T1* [this->height];
		for (int i = 0; i < this->height; i++)
			this->ptr[i] = new T1[this->width];

		for (int i = 0; i < this->height; i++)
			for (int j = 0; j < this->width; j++)
				this->ptr[i][j] = M.ptr[i][j];
	}
	T1 Trace()
	{
		T1 res = 0;
		for (int i = 0; i < this->height; i++)
			res += this->ptr[i][i];
		return res;
	}

	Matrix operator+(Matrix M1)
	{
		Matrix res(this->height, this->width);
		for (int i = 0; i < this->height; i++)
			for (int j = 0; j < this->width; j++)
				res.ptr[i][j] = this->ptr[i][j] + M1.ptr[i][j];
		return res;
	}
	Matrix operator+()
	{
		Matrix res(this->width, this->height);
		for (int i = 0; i < this->height; i++)
			for (int j = 0; j < this->width; j++)
				res.ptr[j][i] = this->ptr[i][j];
		return res;
	}

	T1* operator* (T1* arr)
	{
		T1* res = new T1 [this->height];
		for (int i = 0; i < this->height; i++)
			res[i] = ScalarProduct(this->ptr[i], arr, this->width);
		return res;
	}
	friend ostream& operator<< (ostream& s, Matrix<T1>& M)
	{
    	if(typeid(s)==typeid(ofstream))
		{
			s << M.height << " " << M.width << " ";
			for (int i = 0; i < M.height; i++)
				for (int j = 0; j < M.width; j++)
					cout << M.ptr[i][j] << " ";
		}
		else
		{
			for (int i = 0; i < M.height; i++)
				for (int j = 0; j < M.width; j++)
					cout << M.ptr[i][j] << "\t";
				cout << "\n";
		}
		return s;
	}
	friend istream& operator>> (istream& s, Matrix<T1>& M)
	{
    	if(typeid(s) == typeid(ifstream))
		{
			int height, width;
			s >> height >> width;
			if(height <= 0 || width <= 0)
				throw WrongSizeException(height,width);
			if(height != M.height || width != M.width)
				throw Exception("Wrong dimensions of readinf file");
			for (int i = 0; i < M.height; i++)
				for (int j = 0; j < M.width; j++)
				    try 
					{
					    cout >> M.ptr[i][j];
					}
					catch (...) 
					{
						cout<<"Неверный ввод\n";
					}
		}
	else
		{
			for (int i = 0; i < M.height; i++)
				for (int j = 0; j < M.width; j++)
				   	try 
					{
					    cout >> M.ptr[i][j];
					}
					catch (...) 
					{
						cout<<"Неверный ввод\n";
					}
		}
	return s;
    }
    
    Matrix(istream& in)
	{
		in >> this->height >> this->width;

		if (this->height <= 0 || this->width <= 0)
		{
			throw WrongSizeException("Ошибка в размерах матрицы -> ", this->height, this->width);
		}
		this->ptr = new T1 * [this->height];

		for (int i = 0; i < this->height; ++i)
			this->ptr[i] = new T1[this->width];

		for (int i = 0; i < this->height; i++)
			for (int j = 0; j < this->width; ++j)
				in >> this->ptr[i][j];
	}

    
	void Random()
	{
		for (int i = 0; i < this->height; ++i)
			for (int j = 0; j < this->width;++j)
				this->ptr[i][j] = (T1)((rand()% 256));
	}
	virtual T1& operator[](Matrix<T1> M1)
    {
       return M1.ptr[this->height][this->width];
    }
	Matrix<T1> Centre_of_mass()
	{
	    T1 X = 0, Y = 0, sum = 0;
		Matrix<T1> Answer(2, 1);
		
		for (int i = 0; i < this->height;i++)
			for (int j = 0; j < this->width;++j)
			{
			    X += i * this->ptr[i][j];
			    Y += j * this->ptr[i][j];
			    sum += this->ptr[i][j];
			 
			}
	
		Answer.ptr[0][0] = X / sum ;
		Answer.ptr[1][0] = Y / sum;
        
        return Answer;
    }
	virtual	void print()
	{
		//вывод
		for (int i = 0; i < this->height; i++)
			for (int j = 0; j < this->width; j++)
				cout << this->ptr[i][j] << " ";
			cout << "\n";
	}
};

int main()
{
    Matrix<double> answer(2, 1);
	Matrix<double> M(4,4);
	
	M.Random();
	M.print();
	
	answer = M.Centre_of_mass();
	answer.print();
	
    Matrix<double> M1(3,1);
    M1(0,0)= 2; M1(1,0) = 1; M1(2,0)= 3;
    
    //Matrix<double> M2(3,1);
    //M2(0,0)= 3; M2(1,0) = 1; M2(2,0)= 2;
    
    int n;
    cout << "Введите количество матриц:";
    cin >> n;
    ofstream out("test_OOP5.txt");
    if (out.is_open()) 
    {
        for(int i = 0; i < n;i++)
        {
            out << M1 <<"\n";
        }
      out << answer << "\n";
	  out.close();
    }
    
	ifstream in("test_OOP5.txt");
	if(in.is_open()) 
		{
		     in >> n;
		     for(int i = 0; i < n;i++)
            {
                Matrix<double> txt(in);
                txt.print();
            }
        	in.close();
		}

	cout << '\n';
	
    try
	{
		Matrix<double>	M(-2, 0);
	}
	catch (IndexOutOfBoundsException e)
	{
		cout << "Exception has been caught" ; e.print();
	}
	catch (WrongSizeException e)
	{
		cout << "Exception has been caught" ; e.print();
	}
	catch (Exception e)
	{
		cout << "Exception has been caught" ; e.print();
	}
	catch (exception e)
	{
		cout << "Exception has been caught" ; e.what();
	}
	catch (...)
	{
		cout << "Exception has been caught" ; 
	}
	char c; cin >> c;

	return 0;
}


