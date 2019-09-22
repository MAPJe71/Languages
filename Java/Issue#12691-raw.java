public class MyClass
{
    void method() 
    {
    }
}

public class OuterClass 
{
    private class InnerClass 
    {
        void innerMethod() 
        {
        }
    }
    void outerMethod() 
    {
    }
} 

public class MyCollection<T> implements Collection<T> 
{
    void overrideCollectionMethods() 
    {
    }
}

public class MyCollection<T extends MyInterface> 
{
    void someMethod() 
    {
    }
}

public interface MyInterface 
{
    public void method();
}

