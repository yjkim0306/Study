#include "rbtree.h"

static void _left_rotate(struct rb_tree *tree, struct rb_node *x) {
  struct rb_node *y = x->right;
  x->right = y->left;
  if (y->left != 0)
    y->left->parent = x;
  y->parent = x->parent;
  if (x->parent == 0) // x was root
    tree->root = y;
  else if (x == x->parent->left) // x was left child
    x->parent->left = y;
  else // x was right child
    x->parent->right = y;
  y->left = x;
  x->parent = y;
}

static void _right_rotate(struct rb_tree *tree, struct rb_node *y) {
  struct rb_node *x = y->left;
  y->left = x->right;
  if (x->right != 0)
    x->right->parent = y;
  x->parent = y->parent;
  if (y->parent == 0) // y was root
    tree->root = x;
  else if (y == y->parent->left) // y was left child
    y->parent->left = x;
  else // y was right child
    y->parent->right = x;
  x->right = y;
  y->parent = x;
}

static void _insert_fixup(struct rb_tree *tree, struct rb_node *z) {
  while (z->parent != 0 && z->parent->color == RED) {
    if (z->parent == z->parent->parent->left) {
      struct rb_node *y = z->parent->parent->right; // uncle
      if (y != 0 && y->color == RED) {
        // Case 1: Uncle is RED
        z->parent->color = BLACK;
        y->color = BLACK;
        z->parent->parent->color = RED;
        z = z->parent->parent;
      } else {
        if (z == z->parent->right) {
          // Case 2: Uncle is BLACK and z is a right child
          z = z->parent;
          _left_rotate(tree, z);
        }
        // Case 3: Uncle is BLACK and z is a left child
        z->parent->color = BLACK;
        z->parent->parent->color = RED;
        _right_rotate(tree, z->parent->parent);
      }
    } else {
      // Mirror case: z's parent is a right child
      struct rb_node *y = z->parent->parent->left; // uncle
      if (y != 0 && y->color == RED) {
        // Case 1: Uncle is RED
        z->parent->color = BLACK;
        y->color = BLACK;
        z->parent->parent->color = RED;
        z = z->parent->parent;
      } else {
        if (z == z->parent->left) {
          // Case 2: Uncle is BLACK and z is a left child
          z = z->parent;
          _right_rotate(tree, z);
        }
        // Case 3: Uncle is BLACK and z is a right child
        z->parent->color = BLACK;
        z->parent->parent->color = RED;
        _left_rotate(tree, z->parent->parent);
      }
    }
  }
  tree->root->color = BLACK;
}

void rb_insert(struct rb_tree *tree, struct rb_node *z) {
  struct rb_node *y = 0;
  struct rb_node *x = tree->root;

  // Standard Binary Search Tree insertion
  while (x != 0) {
    y = x;
    if (z->key < x->key)
      x = x->left;
    else
      x = x->right;
  }

  z->parent = y;
  if (y == 0)
    tree->root = z;
  else if (z->key < y->key)
    y->left = z;
  else
    y->right = z;

  z->left = 0;
  z->right = 0;
  z->color = RED;

  _insert_fixup(tree, z);
}

static void _rb_transplant(struct rb_tree *tree, struct rb_node *u, struct rb_node *v) {
  if (u->parent == 0)
    tree->root = v;
  else if (u == u->parent->left)
    u->parent->left = v;
  else
    u->parent->right = v;
  if (v != 0)
    v->parent = u->parent;
}

static void _delete_fixup(struct rb_tree *tree, struct rb_node *x, struct rb_node *x_parent) {
  while (x != tree->root && (x == 0 || x->color == BLACK)) {
    if (x == x_parent->left) {
      struct rb_node *w = x_parent->right; // sibling
      if (w->color == RED) {
        // Case 1: Sibling is RED
        w->color = BLACK;
        x_parent->color = RED;
        _left_rotate(tree, x_parent);
        w = x_parent->right;
      }
      if ((w->left == 0 || w->left->color == BLACK) &&
          (w->right == 0 || w->right->color == BLACK)) {
        // Case 2: Sibling's children are both BLACK
        w->color = RED;
        x = x_parent;
        x_parent = x->parent;
      } else {
        if (w->right == 0 || w->right->color == BLACK) {
          // Case 3: Sibling's right child is BLACK (left is RED)
          if (w->left) w->left->color = BLACK;
          w->color = RED;
          _right_rotate(tree, w);
          w = x_parent->right;
        }
        // Case 4: Sibling's right child is RED
        w->color = x_parent->color;
        x_parent->color = BLACK;
        if (w->right) w->right->color = BLACK;
        _left_rotate(tree, x_parent);
        x = tree->root;
      }
    } else {
      // Mirror case: x is a right child
      struct rb_node *w = x_parent->left; // sibling
      if (w->color == RED) {
        // Case 1: Sibling is RED
        w->color = BLACK;
        x_parent->color = RED;
        _right_rotate(tree, x_parent);
        w = x_parent->left;
      }
      if ((w->right == 0 || w->right->color == BLACK) &&
          (w->left == 0 || w->left->color == BLACK)) {
        // Case 2: Sibling's children are both BLACK
        w->color = RED;
        x = x_parent;
        x_parent = x->parent;
      } else {
        if (w->left == 0 || w->left->color == BLACK) {
          // Case 3: Sibling's left child is BLACK (right is RED)
          if (w->right) w->right->color = BLACK;
          w->color = RED;
          _left_rotate(tree, w);
          w = x_parent->left;
        }
        // Case 4: Sibling's left child is RED
        w->color = x_parent->color;
        x_parent->color = BLACK;
        if (w->left) w->left->color = BLACK;
        _right_rotate(tree, x_parent);
        x = tree->root;
      }
    }
  }
  if (x != 0)
    x->color = BLACK;
}

void rb_delete(struct rb_tree *tree, struct rb_node *z) {
  struct rb_node *y = z;
  struct rb_node *x;
  struct rb_node *x_parent;
  rb_color y_original_color = y->color;

  if (z->left == 0) {
    x = z->right;
    x_parent = z->parent;
    _rb_transplant(tree, z, z->right);
  } else if (z->right == 0) {
    x = z->left;
    x_parent = z->parent;
    _rb_transplant(tree, z, z->left);
  } else {
    y = rb_first(z->right);
    y_original_color = y->color;
    x = y->right;
    if (y->parent == z) {
      x_parent = y;
    } else {
      x_parent = y->parent;
      _rb_transplant(tree, y, y->right);
      y->right = z->right;
      y->right->parent = y;
    }
    _rb_transplant(tree, z, y);
    y->left = z->left;
    y->left->parent = y;
    y->color = z->color;
  }

  if (y_original_color == BLACK)
    _delete_fixup(tree, x, x_parent);
}

struct rb_node* rb_first(struct rb_node *node) {
  if (node == 0) return 0;
  while (node->left != 0)
    node = node->left;
  return node;
}

struct rb_node* rb_last(struct rb_node *node) {
  if (node == 0) return 0;
  while (node->right != 0)
    node = node->right;
  return node;
}
