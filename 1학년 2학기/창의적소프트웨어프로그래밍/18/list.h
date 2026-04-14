/* 221125 LAB 18 */
#include <iostream>
using namespace std;

template <class T>
class Node
{
    public:
        T data;
        Node<T>* next;
};

template <class T>
class List{
    private:
        Node<T> *head;
    public:
        List() : head(NULL) {};

        ~List()
        {
            while(head != NULL)
            {
                Node<T> *temp = head;
                head = head->next;
                delete temp;
            }
            delete head;
        }

        List(T* arr, int n_nodes)
        {
            head = new Node<T>;
            head->next = NULL;
            for(int i = n_nodes-1; i >= 0; i--)
            {
                Node<T>* new_node = new Node<T>;
                new_node->data = arr[i];
                new_node->next = head->next;
                head->next = new_node;
            }
        }

        void insert_at(int idx, const T& data)
        {
            Node<T>* insert = new Node<T>;
            insert->data = data;
            Node<T>* index = head;
            for(int i = 0; i < idx; i++)
            {
                index = index->next;
            }
            insert->next = index->next;
            index->next =insert;
        }

        void remove_at(int idx)
        {
            Node<T>* index = head;
            for(int i = 0; i < idx; i++)
            {
                index = index->next;
            }
            Node<T>* remove = index->next;
            index->next = remove->next;
            delete remove;
        }

        void pop_back()
        {
            Node<T>* pop = head;
            while(pop->next->next != NULL) 
            {
                pop = pop->next;
            }
            delete pop->next;
            pop->next = NULL;
        }

        void push_back(const T& val)
        {
            Node<T>* push = new Node<T>;
            push->data = val;
            push->next = NULL;
            
            Node<T>* idx = head;
            while(idx->next != NULL) 
            {
                idx = idx->next;
            }
            idx->next = push;
        }

        void pop_front()
        {
            Node<T>* pop = head->next;
            head->next = pop->next;
            delete pop;
        }

        void push_front(const T& val)
        {
            Node<T>* push = new Node<T>;
            push->data = val;
            push->next = head->next;
            head->next = push;
        }

        friend ostream& operator<<(ostream& out, List& rhs)
        {
            for(Node<T> *temp = rhs.head->next; temp != NULL; temp = temp->next)
            {
                cout << temp->data;
                if(temp->next != NULL) cout << ",";
            }
            return out;
        }
};
