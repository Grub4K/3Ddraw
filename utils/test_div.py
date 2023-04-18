import itertools

import tqdm
from conv import from_float, from_int

limit = 256 << 4
samples = itertools.product(range(limit), range(1, limit))

progress = tqdm.tqdm(samples, total=limit * (limit - 1))

shift_first_acc = mult_acc = native_acc = 0
for a, b in progress:
    shift_first = (a << 8) // b  # & 0xFFFFFF
    mult = (a * ((1 << 16) // b)) >> 8
    float_result = from_float(from_int(a) / from_int(b))
    if shift_first != mult:
        if float_result == shift_first:
            shift_first_acc += 1
        elif float_result == mult:
            mult_acc += 1
        else:
            native_acc += 1
    elif float_result != mult:
        native_acc += 1

    progress.desc = f"{shift_first_acc:>4}, {mult_acc:>4}, {native_acc:>4}"
