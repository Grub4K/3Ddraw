from __future__ import annotations

import argparse


def from_int(number: int, radix: int) -> float:
    return number / (1 << radix)


def from_float(number: float, radix: int) -> int:
    return int(number * (1 << radix))


def from_float_with_differences(number: float, radix: int):
    result = from_float(number, radix)

    for shift in [-1, 0, 1]:
        value = result + shift
        round_trip = from_int(value, radix)
        diff = abs(round_trip - number)

        yield diff, round_trip, value


def get_arguments() -> tuple[int | float, int]:
    parser = argparse.ArgumentParser(
        prog="conv.py",
        description="A converter from and to the radix number format used in Grub4K/3Ddraw",
    )
    parser.add_argument(
        "number",
        metavar="<number>",
        help="The number to convert from.",
    )
    parser.add_argument(
        "-i",
        "--int",
        dest="int",
        action="store_true",
        help="Convert from internal to float. Default is to convert from float to internal.",
    )
    parser.add_argument(
        "-r",
        "--radix",
        type=int,
        default=8,
        help="The radix point against which to convert the number (default: 8)",
    )
    args = parser.parse_args()

    try:
        return int(args.number) if args.int else float(args.number), int(args.radix)
    except ValueError as e:
        parser.error(str(e))


def main():
    number, radix = get_arguments()

    if isinstance(number, float):
        diff, round_trip, result = min(from_float_with_differences(number, radix))
        output = f"{round_trip} => {result} [{diff:.8f}]"

    else:
        result = from_int(number, radix)
        output = f"{number} => {result}"

    print(output)


if __name__ == "__main__":
    main()
