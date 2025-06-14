import math

PI = 3.14159265358979323846
TABLE_SIZE = 8192

START_ANGLE = -2.0 * PI
END_ANGLE = 2.0 * PI
ANGLE_RANGE = END_ANGLE - START_ANGLE

with open("./tan.h", "w") as f:
    f.write(f"// This file was automatically generated.\n")
    f.write(f"// Do not edit directly.\n\n")
    f.write(f"const float TanTable[8192] = {{")
    f.write("\n")
    for i in range(TABLE_SIZE):

        angle = START_ANGLE + (float(i) / TABLE_SIZE) * ANGLE_RANGE
        value = math.tan(angle)
        f.write(f"    {value:.10f}f")
        if i != TABLE_SIZE - 1:
            f.write(",")

        if (i + 1) % 4 == 0:
            f.write("\n")
        else:
            f.write(" ")

    f.write(f"\n}};")