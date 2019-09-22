//  https://notepad-plus-plus.org/community/topic/12691/function-list-with-java-problems
//
//  1.  closing bracket “}” must not be the last character
//      there must be at least one chcracter beyond. Can be space or newline.

public class MyClass {
    void method() {
    }
}

//  2.  comments don’t work at all
//      If there is comment inside my class the function list produces no output at all.

public class MyClass {
    // this comment must not be here
    /* this also breaks the functionlist */
    void method() {
        // even this comment is wrong
    }
} 

//  3.  nested classes not recognized
//      No support for nested classes. I would really appreciate if ClassRange would be recursive

public class OuterClass {
    private class InnerClass { // this class is not in functionlist
        void innerMethod() { // this method is placed in OuterClass
        }
    }
    void outerMethod() {
    }
} 

//  4.  template classes extending other templates
//      I created my custom Collection. The implemented interface destroyed the function list.

public class MyCollection<T> implements Collection<T> {
    void overrideCollectionMethods() {
    }
}

//  5.  templates limiting the template type
//      My collection was used for certain types only. This was also not recognized.

public class MyCollection<T extends MyInterface> {
    void someMethod() {
    }
}

//  6.  interface (abstract classes) methods are not recognized
//      regex for method recognition requires method implementation {…}. Abstract methods are not recognized.

public interface MyInterface {
    public void method();
}

