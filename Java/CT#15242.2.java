
// https://notepad-plus-plus.org/community/topic/15242/java-function-list-problems-with-implements

public interface IGraph {
    void doDraw(String string);
    void doColour(int colour);

    interface IGraphInternals {
        void doDetailedDrawing();
        void doDetailedColouring();
    }
}

public interface ITelephone {
    void doRing(int number);
    void doAnswer(int number);
}

