package Week14.Practice2;
import java.util.ArrayList;

public class PriorityQueue<T> {
    private ArrayList<T> itemArray = new ArrayList<>();
    private ArrayList<Integer> priorityArray = new ArrayList<>();

    public void add(T item, int priority)
    {
        itemArray.add(item);
        priorityArray.add(priority);
    }
    public T remove()
    {
        if(itemArray.size() == 0)
            return null;
        int max = 0;
        for(int i = 0; i < priorityArray.size(); i++)
        {
            if(priorityArray.get(i) > max) {
                max = priorityArray.get(i);
            }
        }
        T ret = itemArray.get(priorityArray.indexOf(max));
        itemArray.remove(priorityArray.indexOf(max));
        priorityArray.remove(priorityArray.indexOf(max));
        return ret;
    }
}
