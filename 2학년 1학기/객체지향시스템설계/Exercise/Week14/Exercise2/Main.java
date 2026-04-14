package Week14.Practice2;

public class Main {
    public static void main(String[] args) {
        PriorityQueue<String> q = new PriorityQueue<>();
        q.add("X", 10);
        q.add("Y", 1);
        q.add("Z", 3);

        System.out.println(q.remove()); // Returns X
        System.out.println(q.remove()); // Returns Z
        System.out.println(q.remove()); // Returns Z
        System.out.println(q.remove()); // Returns null
    }
}
