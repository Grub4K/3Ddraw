import argparse
import math

RADIX_POINT = 8


def from_int(number: int) -> float:
    sign = math.copysign(1, number)
    number = abs(number)
    result = float(number >> RADIX_POINT)

    fraction = 1.0
    mask = 1 << RADIX_POINT
    for _ in range(RADIX_POINT):
        mask >>= 1
        fraction /= 2
        if number & mask:
            result += fraction

    return sign * result


def from_float(number: float) -> int:
    sign = int(math.copysign(1, number))

    fractional, decimal = math.modf(abs(number))
    result = int(decimal)

    fraction = 1.0
    for _ in range(RADIX_POINT):
        result <<= 1
        fraction /= 2
        if fractional >= fraction:
            result += 1
            fractional -= fraction

    return sign * result


def from_float_with_differences(number: float):
    result = from_float(number)

    for shift in [-1, 0, 1]:
        value = result + shift
        round_trip = from_int(value)
        diff = abs(round_trip - number)

        yield diff, round_trip, value


def get_number_argument() -> int | float:
    parser = argparse.ArgumentParser(
        prog="conv.py",
        description="A converter from and to the number format used in Grub4K/3Ddraw.bat",
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
    args = parser.parse_args()

    try:
        return int(args.number) if args.int else float(args.number)
    except ValueError as e:
        parser.error(str(e))


def main():
    number = get_number_argument()

    if isinstance(number, float):
        diff, round_trip, result = min(from_float_with_differences(number))
        output = f"{round_trip} => {result} [{diff:.8f}]"

    else:
        result = from_int(number)
        output = f"{number} => {result}"

    print(output)


if __name__ == "__main__":
    main()
