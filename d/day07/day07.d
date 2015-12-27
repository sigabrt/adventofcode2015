import std.stdio;
import std.string;
import std.conv;

enum ConnectionType {
  ASSIGN,
  LSHIFT,
  RSHIFT,
  AND,
  OR,
  NOT
}

class Connection {
  ConnectionType type;
  ushort val;

  Node[] inputNodes;
}

class Node {
  string id;
  Connection inputConnection;
}

Node nodeFromInstruction(string instruction, ref Node[string] cache) {
  string[] parts = instruction.split(" ");
  if (parts.length < 3) {
    throw new Exception("don't know how to deal with this instruction: " ~ instruction);
  }

  string nodeId = parts[$-1];

  Node node;
  if (nodeId in cache) {
    node = cache[nodeId];
  } else {
    node = new Node();
    node.id = nodeId;
  }

  // Simplest case, node with a value connection
  // Example: 123 -> x
  // Example: y -> x
  if (parts.length == 3) {
    string arg = parts[0];

    Connection conn = new Connection();
    conn.type = ConnectionType.ASSIGN;

    if (arg.isNumeric()) {
      conn.val = to!ushort(parts[0]);
    } else {
      if (arg in cache) {
        conn.inputNodes = [cache[arg]];
      } else {
        Node inputNode = new Node();
        inputNode.id = arg;
        conn.inputNodes = [inputNode];

        cache[inputNode.id] = inputNode;
      }
    }

    node.inputConnection = conn;
  }

  // The bitwise complement of either a value or another node
  // Example: NOT 2 -> x
  // Example: NOT y -> x
  if (parts.length == 4) {
    string arg = parts[1];

    Connection conn = new Connection();
    conn.type = ConnectionType.NOT;

    if (arg.isNumeric()) {
      // TODO: Optimize the connection into a value connection by
      // precomputing the NOT operation.
      conn.val = to!ushort(arg);
    } else {
      if (arg in cache) {
        conn.inputNodes = [cache[arg]];
      } else {
        Node notInputNode = new Node();
        notInputNode.id = arg;
        conn.inputNodes = [notInputNode];

        cache[notInputNode.id] = notInputNode;
      }
    }

    node.inputConnection = conn;
  }

  // Example: x LSHIFT y -> z
  // Example: 1 AND a -> b
  if (parts.length == 5) {
    string arg1 = parts[0];
    string op   = parts[1];
    string arg2 = parts[2];

    Connection conn = new Connection();

    if (arg1.isNumeric()) {
      conn.val = to!ushort(arg1);
    } else {
      if (arg1 in cache) {
        conn.inputNodes ~= [cache[arg1]];
      } else {
        Node inputNode = new Node();
        inputNode.id = arg1;

        conn.inputNodes ~= [inputNode];
        cache[inputNode.id] = inputNode;
      }
    }

    if (arg2.isNumeric()) {
      // TODO: Assuming that parts[0] is a node ID and not a numeric
      // value, otherwise we would be overwriting it here.
      conn.val = to!ushort(arg2);
    } else {
      if (arg2 in cache) {
        conn.inputNodes ~= [cache[arg2]];
      } else {
        Node inputNode = new Node();
        inputNode.id = arg2;

        conn.inputNodes ~= [inputNode];
        cache[inputNode.id] = inputNode;
      }
    }

    switch (op) {
      case "LSHIFT":
        conn.type = ConnectionType.LSHIFT;
        break;
      case "RSHIFT":
        conn.type = ConnectionType.RSHIFT;
        break;
      case "AND":
        conn.type = ConnectionType.AND;
        break;
      case "OR":
        conn.type = ConnectionType.OR;
        break;
      default:
        throw new Exception("unrecognized gate type: " ~ parts[1]);
    }

    node.inputConnection = conn;
  }

  cache[node.id] = node;
  return node;
}

unittest {
  Node[string] cache;

  Node test1 = nodeFromInstruction("123 -> x", cache);
  assert(test1.id == "x");
  assert(test1.inputConnection.type == ConnectionType.ASSIGN);
  assert(test1.inputConnection.val == 123);
  assert(cache["x"] == test1);

  Node test2 = nodeFromInstruction("a -> b", cache);
  assert(test2.id == "b");
  assert(test2.inputConnection.type == ConnectionType.ASSIGN);
  assert(test2.inputConnection.inputNodes.length == 1);
  assert(test2.inputConnection.inputNodes[0].id == "a");
  assert(cache["a"] == test2.inputConnection.inputNodes[0]);
}

unittest {
  Node[string] cache;

  Node test = nodeFromInstruction("NOT 234 -> a", cache);
  assert(test.id == "a");
  assert(test.inputConnection.type == ConnectionType.NOT);
  assert(test.inputConnection.val == 234);
}

unittest {
  Node[string] cache;

  Node test = nodeFromInstruction("NOT b -> a", cache);
  assert(test.id == "a");
  assert(test.inputConnection.type == ConnectionType.NOT);
  assert(test.inputConnection.inputNodes.length == 1);
  assert(test.inputConnection.inputNodes[0].id == "b");
  assert(cache["b"] == test.inputConnection.inputNodes[0]);
}

unittest {
  Node[string] cache;

  Node test = nodeFromInstruction("x LSHIFT y -> z", cache);
  assert(test.id == "z");
  assert(test.inputConnection.type == ConnectionType.LSHIFT);
  assert(test.inputConnection.inputNodes.length == 2);

  Node node1 = test.inputConnection.inputNodes[0];
  assert(node1.id == "x");
  assert(cache["x"] == node1);

  Node node2 = test.inputConnection.inputNodes[1];
  assert(node2.id == "y");
  assert(cache["y"] == node2);
}

ushort findValue(Node node, ref ushort[string] cache) {
  if (node.id in cache) {
    return cache[node.id];
  }

  ushort val;
  Connection conn = node.inputConnection;
  switch (conn.type) {
    case ConnectionType.ASSIGN:
      if (conn.inputNodes.length == 0) {
        val = conn.val;
      } else {
        val = findValue(conn.inputNodes[0], cache);
      }
      break;
    case ConnectionType.LSHIFT:
      if (conn.inputNodes.length == 1) {
        // TODO: Handle both cases, i.e. 1 LSHIFT x and x LSHIFT 1
        val = (findValue(conn.inputNodes[0], cache) << conn.val) & ushort.max;
      } else if (conn.inputNodes.length == 2) {
        val = (findValue(conn.inputNodes[0], cache) << findValue(conn.inputNodes[1], cache)) & ushort.max;
      } else {
        throw new Exception("an LSHIFT connection contains " ~
                            to!string(conn.inputNodes.length) ~
                            " nodes, can't handle it");
      }
      break;
    case ConnectionType.RSHIFT:
      if (conn.inputNodes.length == 1) {
        // TODO: Handle both cases, i.e. 1 RSHIFT x and x RSHIFT 1
        val = (findValue(conn.inputNodes[0], cache) >> conn.val) & ushort.max;
      } else if (conn.inputNodes.length == 2) {
        val = (findValue(conn.inputNodes[0], cache) >> findValue(conn.inputNodes[1], cache)) & ushort.max;
      } else {
        throw new Exception("an RSHIFT connection contains " ~
                            to!string(conn.inputNodes.length) ~
                            " nodes, can't handle it");
      }
      break;
    case ConnectionType.AND:
      if (conn.inputNodes.length == 1) {
        // TODO: Handle both cases, i.e. 1 AND x and x AND 1
        val = (findValue(conn.inputNodes[0], cache) & conn.val);
      } else if (conn.inputNodes.length == 2) {
        val = (findValue(conn.inputNodes[0], cache) & findValue(conn.inputNodes[1], cache));
      } else {
        throw new Exception("an AND connection contains " ~
                            to!string(conn.inputNodes.length) ~
                            " nodes, can't handle it");
      }
      break;
    case ConnectionType.OR:
      if (conn.inputNodes.length == 1) {
        // TODO: Handle both cases, i.e. 1 OR x and x OR 1
        val = (findValue(conn.inputNodes[0], cache) | conn.val);
      } else if (conn.inputNodes.length == 2) {
        val = (findValue(conn.inputNodes[0], cache) | findValue(conn.inputNodes[1], cache));
      } else {
        throw new Exception("an OR connection contains " ~
                            to!string(conn.inputNodes.length) ~
                            " nodes, can't handle it");
      }
      break;
    case ConnectionType.NOT:
      if (conn.inputNodes.length == 0) {
        val = ~conn.val;
      } else {
        val = ~findValue(conn.inputNodes[0], cache);
      }
      break;
    default:
      throw new Exception("unknown connection type: " ~ to!string(conn.type));
  }

  cache[node.id] = val;
  return val;
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("123 -> x", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 123);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("y -> x", graphCache);
  Node y = nodeFromInstruction("456 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 456);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("y LSHIFT 1 -> x", graphCache);
  Node y = nodeFromInstruction("123 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 246);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node z = nodeFromInstruction("x LSHIFT y -> z", graphCache);
  Node x = nodeFromInstruction("123 -> x", graphCache);
  Node y = nodeFromInstruction("3 -> y", graphCache);
  assert(findValue(graphCache["z"], evalCache) == 984);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node z = nodeFromInstruction("x LSHIFT y -> z", graphCache);
  Node x = nodeFromInstruction("a -> x", graphCache);
  Node y = nodeFromInstruction("3 -> y", graphCache);
  Node a = nodeFromInstruction("123 -> a", graphCache);
  assert(findValue(graphCache["z"], evalCache) == 984);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("y RSHIFT 1 -> x", graphCache);
  Node y = nodeFromInstruction("123 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 61);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node z = nodeFromInstruction("x RSHIFT y -> z", graphCache);
  Node x = nodeFromInstruction("123 -> x", graphCache);
  Node y = nodeFromInstruction("3 -> y", graphCache);
  assert(findValue(graphCache["z"], evalCache) == 15);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("y AND 1 -> x", graphCache);
  Node y = nodeFromInstruction("123 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 1);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node z = nodeFromInstruction("x AND y -> z", graphCache);
  Node x = nodeFromInstruction("123 -> x", graphCache);
  Node y = nodeFromInstruction("3 -> y", graphCache);
  assert(findValue(graphCache["z"], evalCache) == 3);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("y OR 5 -> x", graphCache);
  Node y = nodeFromInstruction("123 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == 127);
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("NOT 2 -> x", graphCache);
  assert(findValue(graphCache["x"], evalCache) == ~cast(ushort)(2));
}

unittest {
  Node[string] graphCache;
  ushort[string] evalCache;

  Node x = nodeFromInstruction("NOT y -> x", graphCache);
  Node y = nodeFromInstruction("5643 -> y", graphCache);
  assert(findValue(graphCache["x"], evalCache) == ~cast(ushort)(5643));
}

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  Node[string] graphCache;
  ushort[string] evalCache;

  foreach (line; input.byLine()) {
    nodeFromInstruction(to!string(line), graphCache);
  }

  ushort a = findValue(graphCache["a"], evalCache);
  writeln("value of a: ", a);

  writeln("changing value of b to ", a);
  nodeFromInstruction(to!string(a) ~ " -> b", graphCache);

  // Clear the cache so everything will be reevaluated
  evalCache = null;

  a = findValue(graphCache["a"], evalCache);
  writeln("new value of a: ", a);

  return 0;
}
