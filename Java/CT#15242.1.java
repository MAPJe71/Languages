
// https://notepad-plus-plus.org/community/topic/15242/java-function-list-problems-with-implements

// Example of fail when adding dot-separated implements:
public class GraphIssue1 implements IGraph, IGraph.IGraphInternal, ITelephone {

    public static void main(String[] args) {
        // method body
    }
}

// Example of fail when `implements` is/are on a different line:
public class GraphIssue2 implements IGraph
    , ITelephone {

    public static void main(String[] args) {
        // method body
    }
}
