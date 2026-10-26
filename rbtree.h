#include "types.h"
#include "spinlock.h"

typedef enum { RED, BLACK } rb_color;

struct rb_node {
  uint64 key;
  void *data;
  struct rb_node *parent;
  struct rb_node *left;
  struct rb_node *right;
  rb_color color;
};

struct rb_tree {
  struct rb_node *root;
  struct spinlock lock;
};

void rb_insert(struct rb_tree *tree, struct rb_node *node);
void rb_delete(struct rb_tree *tree, struct rb_node *node);

struct rb_node* rb_first(struct rb_node *node); // minimum
struct rb_node* rb_last(struct rb_node *node); // maximum
