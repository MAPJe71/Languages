
class MyClass
{
public:
    MyClass() {};
    virtual ~MyClass() {};
    
private:
    // Copy constructor
    MyClass( MyClass const & rhs);
    // Assignment operator
    MyClass & operator =( MyClass const & rhs);
}

inline 
MyClass::MyClass( MyClass const & rhs)
{
    return myClass;
}

inline
MyClass & 
MyClass::operator =( MyClass const & rhs)
{
    return myClass;
}