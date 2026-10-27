import bisect
import csv
import json
import sys


class BPlusTree:
    def __init__(self, order: int | None = None, data: dict | None = None):
        if data is not None:
            self.order = data["order"]
            self.root = data["root"]
            self.next_id = data["next_id"]
            self.nodes = {int(k): v for k, v in data["nodes"].items()}
        else:
            if order is None or order < 2:
                raise ValueError("node size b must be at least 2")
            self.order = order
            self.root = 0
            self.next_id = 1
            self.nodes = {0: {"leaf": True, "keys": [], "values": [], "next": None}}

    @property
    def max_keys(self) -> int:
        return self.order - 1

    @property
    def min_leaf_keys(self) -> int:
        return (self.max_keys + 1) // 2

    @property
    def min_internal_children(self) -> int:
        return (self.order + 1) // 2

    def dump(self) -> dict:
        return {"order": self.order, "root": self.root, "next_id": self.next_id, "nodes": self.nodes}

    def _new_leaf(self) -> int:
        node_id = self.next_id
        self.next_id += 1
        self.nodes[node_id] = {"leaf": True, "keys": [], "values": [], "next": None}
        return node_id

    def _new_internal(self, children: list[int]) -> int:
        node_id = self.next_id
        self.next_id += 1
        self.nodes[node_id] = {"leaf": False, "keys": [], "children": children}
        self._refresh(node_id)
        return node_id

    def _minimum(self, node_id: int) -> int:
        node = self.nodes[node_id]
        while not node["leaf"]:
            node = self.nodes[node["children"][0]]
        return node["keys"][0]

    def _refresh(self, node_id: int) -> None:
        node = self.nodes[node_id]
        if not node["leaf"]:
            node["keys"] = [self._minimum(child) for child in node["children"][1:]]

    def _child_index(self, node: dict, key: int) -> int:
        return bisect.bisect_right(node["keys"], key)

    def insert(self, key: int, value: int) -> bool:
        """Insert a pair. Returns False when the key already exists."""
        split = self._insert(self.root, key, value)
        if split is None:
            return True
        old_root = self.root
        self.root = self._new_internal([old_root, split])
        return True

    def _insert(self, node_id: int, key: int, value: int) -> int | None:
        node = self.nodes[node_id]
        if node["leaf"]:
            pos = bisect.bisect_left(node["keys"], key)
            if pos < len(node["keys"]) and node["keys"][pos] == key:
                raise KeyError(key)
            node["keys"].insert(pos, key)
            node["values"].insert(pos, value)
            if len(node["keys"]) <= self.max_keys:
                return None
            return self._split_leaf(node_id)

        child_pos = self._child_index(node, key)
        try:
            split = self._insert(node["children"][child_pos], key, value)
        except KeyError:
            raise
        if split is not None:
            node["children"].insert(child_pos + 1, split)
        self._refresh(node_id)
        if len(node["children"]) <= self.order:
            return None
        return self._split_internal(node_id)

    def _split_leaf(self, node_id: int) -> int:
        left = self.nodes[node_id]
        right_id = self._new_leaf()
        right = self.nodes[right_id]
        cut = (len(left["keys"]) + 1) // 2
        right["keys"] = left["keys"][cut:]
        right["values"] = left["values"][cut:]
        left["keys"] = left["keys"][:cut]
        left["values"] = left["values"][:cut]
        right["next"] = left["next"]
        left["next"] = right_id
        return right_id

    def _split_internal(self, node_id: int) -> int:
        left = self.nodes[node_id]
        cut = len(left["children"]) // 2
        right_children = left["children"][cut:]
        left["children"] = left["children"][:cut]
        right_id = self._new_internal(right_children)
        self._refresh(node_id)
        return right_id

    def search(self, key: int) -> tuple[list[list[int]], int | None]:
        node = self.nodes[self.root]
        path: list[list[int]] = []
        while not node["leaf"]:
            path.append(list(node["keys"]))
            node = self.nodes[node["children"][self._child_index(node, key)]]
        pos = bisect.bisect_left(node["keys"], key)
        value = node["values"][pos] if pos < len(node["keys"]) and node["keys"][pos] == key else None
        return path, value

    def range_search(self, start: int, end: int) -> list[tuple[int, int]]:
        if start > end:
            return []
        node = self.nodes[self.root]
        while not node["leaf"]:
            node = self.nodes[node["children"][self._child_index(node, start)]]
        pos = bisect.bisect_left(node["keys"], start)
        result = []
        while True:
            while pos < len(node["keys"]):
                key = node["keys"][pos]
                if key > end:
                    return result
                result.append((key, node["values"][pos]))
                pos += 1
            if node["next"] is None:
                return result
            node = self.nodes[node["next"]]
            pos = 0

    def delete(self, key: int) -> bool:
        if not self._delete(self.root, key, True):
            return False
        while not self.nodes[self.root]["leaf"] and len(self.nodes[self.root]["children"]) == 1:
            root = self.nodes[self.root]
            old_root = self.root
            self.root = root["children"][0]
            del self.nodes[old_root]
        if not self.nodes[self.root]["leaf"] and not self.nodes[self.root]["children"]:
            old_root = self.root
            self.root = self._new_leaf()
            del self.nodes[old_root]
        self._relink_leaves()
        return True

    def _delete(self, node_id: int, key: int, is_root: bool) -> bool:
        node = self.nodes[node_id]
        if node["leaf"]:
            pos = bisect.bisect_left(node["keys"], key)
            if pos == len(node["keys"]) or node["keys"][pos] != key:
                return False
            del node["keys"][pos]
            del node["values"][pos]
            return True

        child_pos = self._child_index(node, key)
        if not self._delete(node["children"][child_pos], key, False):
            return False
        self._repair_child(node_id, child_pos)
        self._refresh(node_id)
        return True

    def _repair_child(self, parent_id: int, index: int) -> None:
        parent = self.nodes[parent_id]
        child_id = parent["children"][index]
        child = self.nodes[child_id]
        if child["leaf"]:
            minimum = self.min_leaf_keys
            size = len(child["keys"])
        else:
            minimum = self.min_internal_children
            size = 0 if self._subtree_empty(child_id) else len(child["children"])
        if size >= minimum:
            return
        if not child["leaf"] and self._subtree_empty(child_id):
            del parent["children"][index]
            self._drop_subtree(child_id)
            return

        left_id = parent["children"][index - 1] if index else None
        right_id = parent["children"][index + 1] if index + 1 < len(parent["children"]) else None
        if left_id is not None and self._node_size(left_id) > minimum:
            self._borrow_left(left_id, child_id)
            self._refresh(left_id)
            self._refresh(child_id)
            return
        if right_id is not None and self._node_size(right_id) > minimum:
            self._borrow_right(child_id, right_id)
            self._refresh(child_id)
            self._refresh(right_id)
            return
        if left_id is not None:
            self._merge(left_id, child_id)
            del parent["children"][index]
            del self.nodes[child_id]
        elif right_id is not None:
            self._merge(child_id, right_id)
            del parent["children"][index + 1]
            del self.nodes[right_id]

    def _node_size(self, node_id: int) -> int:
        node = self.nodes[node_id]
        return len(node["keys"]) if node["leaf"] else len(node["children"])

    def _subtree_empty(self, node_id: int) -> bool:
        node = self.nodes[node_id]
        while not node["leaf"]:
            if not node["children"]:
                return True
            node = self.nodes[node["children"][0]]
        return not node["keys"]

    def _drop_subtree(self, node_id: int) -> None:
        node = self.nodes[node_id]
        if not node["leaf"]:
            for child_id in list(node["children"]):
                self._drop_subtree(child_id)
        del self.nodes[node_id]

    def _relink_leaves(self) -> None:
        leaves: list[int] = []

        def collect(node_id: int) -> None:
            node = self.nodes[node_id]
            if node["leaf"]:
                leaves.append(node_id)
            else:
                for child_id in node["children"]:
                    collect(child_id)

        collect(self.root)
        for position, leaf_id in enumerate(leaves):
            self.nodes[leaf_id]["next"] = leaves[position + 1] if position + 1 < len(leaves) else None

    def _borrow_left(self, left_id: int, child_id: int) -> None:
        left, child = self.nodes[left_id], self.nodes[child_id]
        if child["leaf"]:
            child["keys"].insert(0, left["keys"].pop())
            child["values"].insert(0, left["values"].pop())
        else:
            child["children"].insert(0, left["children"].pop())

    def _borrow_right(self, child_id: int, right_id: int) -> None:
        child, right = self.nodes[child_id], self.nodes[right_id]
        if child["leaf"]:
            child["keys"].append(right["keys"].pop(0))
            child["values"].append(right["values"].pop(0))
        else:
            child["children"].append(right["children"].pop(0))

    def _merge(self, left_id: int, right_id: int) -> None:
        left, right = self.nodes[left_id], self.nodes[right_id]
        if left["leaf"]:
            left["keys"].extend(right["keys"])
            left["values"].extend(right["values"])
            left["next"] = right["next"]
        else:
            left["children"].extend(right["children"])
            self._refresh(left_id)


def load_tree(index_file: str) -> BPlusTree:
    try:
        with open(index_file, encoding="utf-8") as stream:
            return BPlusTree(data=json.load(stream))
    except FileNotFoundError as error:
        raise ValueError(f"index file not found: {index_file}") from error
    except (json.JSONDecodeError, KeyError, TypeError) as error:
        raise ValueError(f"invalid index file: {index_file}") from error


def save_tree(tree: BPlusTree, index_file: str) -> None:
    with open(index_file, "w", encoding="utf-8") as stream:
        json.dump(tree.dump(), stream, separators=(",", ":"))


def read_insert_csv(filename: str):
    with open(filename, newline="", encoding="utf-8") as stream:
        for line_number, row in enumerate(csv.reader(stream), 1):
            if len(row) != 2:
                raise ValueError(f"{filename}:{line_number}: expected key,value")
            yield int(row[0]), int(row[1])


def read_delete_csv(filename: str):
    with open(filename, newline="", encoding="utf-8") as stream:
        for line_number, row in enumerate(csv.reader(stream), 1):
            if len(row) != 1:
                raise ValueError(f"{filename}:{line_number}: expected one key")
            yield int(row[0])


def usage() -> str:
    return "Usage: bptree.py -c index_file b | -i index_file data_file | -d index_file data_file | -s index_file key | -r index_file start_key end_key"


def main(argv: list[str]) -> int:
    try:
        if len(argv) == 4 and argv[1] == "-c":
            save_tree(BPlusTree(int(argv[3])), argv[2])
        elif len(argv) == 4 and argv[1] == "-i":
            tree = load_tree(argv[2])
            for key, value in read_insert_csv(argv[3]):
                try:
                    tree.insert(key, value)
                except KeyError:
                    continue
            save_tree(tree, argv[2])
        elif len(argv) == 4 and argv[1] == "-d":
            tree = load_tree(argv[2])
            for key in read_delete_csv(argv[3]):
                tree.delete(key)
            save_tree(tree, argv[2])
        elif len(argv) == 4 and argv[1] == "-s":
            path, value = load_tree(argv[2]).search(int(argv[3]))
            for keys in path:
                print(",".join(map(str, keys)))
            print(value if value is not None else "NOT FOUND")
        elif len(argv) == 5 and argv[1] == "-r":
            for key, value in load_tree(argv[2]).range_search(int(argv[3]), int(argv[4])):
                print(f"{key},{value}")
        else:
            raise ValueError(usage())
    except (ValueError, OSError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
