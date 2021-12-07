from __future__ import annotations

import ast
import sys
import opcode
from types import CodeType
from typing import Union, Iterable
from dataclasses import dataclass


@dataclass
class Value:
    value: object

    @classmethod
    def from_str(cls, s: str) -> Value:
        return cls(ast.literal_eval(s))


@dataclass
class Name:
    ident: str


@dataclass
class VarName:
    ident: str


Argument = Union[Value, Name, VarName, int, None]
Opcode = int


def parse(text: str) -> Iterable[tuple[Opcode, Argument]]:
    labels = dict()

    current_opcode_num = 0
    for line in text.splitlines():
        line = line.strip()
        if not line or line[0] == '#':
            continue

        if line == 'DEBUG':
            yield from parse('DUP_TOP\nLOAD_GLOBAL print\nROT_TWO\nCALL_FUNCTION 1\nPOP_TOP')
            continue

        labeled = line.split(':', maxsplit=1)
        if len(labeled) == 2 and labeled[0].isalnum():
            labels[labeled[0]] = current_opcode_num
            line = labeled[1].strip()
        current_opcode_num += 2

        raw_opcode, *opt_raw_argument = line.split(maxsplit=1)
        if opt_raw_argument:
            raw_argument = opt_raw_argument[0]
        else:
            raw_argument = ''

        op = opcode.opmap[raw_opcode]
        argument: Argument
        if raw_argument == '':
            argument = None
        elif raw_argument.isdigit():
            argument = int(raw_argument)
        elif raw_argument[0] == '(':
            argument = Value.from_str(raw_argument)
        elif raw_argument[0] == '$':
            argument = VarName(ident=raw_argument[1:])
        elif raw_argument[0] == ':':
            argument = labels[raw_argument[1:]]
        else:
            argument = Name(ident=raw_argument)
        yield op, argument

def compile_opcodes(text: str) -> CodeType:
    names: dict[str, int] = dict()
    varnames: dict[str, int] = dict()
    values: list[object] = []
    raw_opcodes = list(parse(text))
    opcodes: list[int] = []
    stacksize = 0

    for idx, (op, raw_argument) in enumerate(raw_opcodes):
        opcodes.append(op)
        if isinstance(raw_argument, Value):
            argument = len(values)
            values.append(raw_argument.value)
        elif isinstance(raw_argument, Name):
            names.setdefault(raw_argument.ident, len(names))
            argument = names[raw_argument.ident]
        elif isinstance(raw_argument, VarName):
            varnames.setdefault(raw_argument.ident, len(varnames))
            argument = varnames[raw_argument.ident]
        elif isinstance(raw_argument, int):
            argument = raw_argument
        else:
            opcodes.append(0)
            continue

        opcodes.append(argument)
        stacksize += opcode.stack_effect(op, argument)

    tuple_names = tuple(sorted(names, key=lambda n: names[n]))
    tuple_varnames = tuple(sorted(varnames, key=lambda n: varnames[n]))

    return CodeType(
        0,               # argcount
        0,               # posonlyargcount
        0,               # kwonlyargcount
        len(names),      # nlocals
        stacksize,       # stacksize
        0,               # flags
        bytes(opcodes),  # codestring
        tuple(values),   # constants
        tuple_names,     # names
        tuple_varnames,  # names
        '<asm>',         # filename
        '<asm>',         # name
        1,               # firstlineno
        bytes(),         # lnotab
    )


def run(code: str) -> None:
    def injectee():
        pass

    injectee.__code__ = compile_opcodes(code)
    import dis
    injectee()


def main(filename: str) -> None:
    with open(filename) as file:
        run(file.read())


if __name__ == '__main__':
    main(sys.argv[1])
