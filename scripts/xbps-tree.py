#!/usr/bin/python

import sys
import subprocess


class Node:
    def __init__(self, value):
        self.list = []
        self.value = value

    def print(self):
        self.rprint('', 0, 0)

    def rprint(self, prefix: str, level: int, last: bool):
        fprefix = '' if level == 0 else '├── ' if not last else '└── '
        print(f'{prefix}{fprefix}{self.value}')
        level += 1

        for n in self.list:
            tprefix = '' if level < 2 else '│   ' if not last else '    '
            n.rprint(prefix + tprefix, level, n == self.list[-1])


def get_dependencies(pkg: str):
    result = subprocess.run(['xbps-query', '-x', pkg], capture_output=True, encoding='utf8')
    sorted_output = sorted(result.stdout.splitlines())
    deps = []

    for line in sorted_output:
        dep_node = Node(line.split('>=')[0])
        dep_node.list = get_dependencies(dep_node.value)
        deps.append(dep_node)

    return deps


def tree(pkg: str):
    pkg_node = Node(pkg)
    pkg_node.list = get_dependencies(pkg)
    pkg_node.print()


if len(sys.argv) < 3 or sys.argv[1] != "tree" and sys.argv[1] != "size":
    msg = "usage: {} <command> <package>\n"
    msg += "where <command> is either 'tree' or 'size'"
    print(msg.format(sys.argv[0]), file=sys.stderr)
    exit(1)

if sys.argv[1] == 'tree':
    tree(sys.argv[2])
