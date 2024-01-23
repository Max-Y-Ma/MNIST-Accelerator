# Convert current weight and bias configuration files to fixed point format
import os

# Get a list of all configuration files in directory
directory_path = 'rom/'
file_list = os.listdir(directory_path)

# Fixed point format
data_width = 24
integer_width = 9
decimal_width = data_width - integer_width

# Convert bias file contents to fixed point format
for file in file_list:
    # Check bias file
    if 'bias' not in file:
        continue

    # Open file
    with open(directory_path + file, 'r') as f:
        lines = f.readlines()

    # Convert each line to fixed point format
    for i in range(len(lines)):
        # Get bias value
        bias = float(lines[i])

        # Convert to fixed point format
        bias = int(bias * (2 ** decimal_width))

        # Convert to binary
        if (bias < 0):
            # Take 2's complement
            bias = ''.join(['1' if bit == '0' else '0' for bit in bin(bias)[3:]])
            bias_length = len(bias)
            bias_complement = bin(int(bias, 2) + 1)[2:]

            bias = f"{'1' * (data_width - bias_length)}{bias_complement.zfill(bias_length)}"
        else:
            bias = bin(bias)[2:].zfill(data_width)

        # Write back to file
        lines[i] = bias + '\n'

    # Write back to file
    with open('rom/' + file + '.mif', 'w') as f:
        f.writelines(lines)

# Convert weight file contents to fixed point format
for file in file_list:
    # Check weight file
    if 'weight' not in file:
        continue

    # Open file
    with open(directory_path + file, 'r') as f:
        lines = f.readlines()

    # Convert each line to fixed point format in a separate file
    weight_count = 0
    for i in range(len(lines)):
        # Get weight values
        values = lines[i].split(',')

        weight_lines = []
        for value in values:
            # Convert to fixed point format
            weight = float(value)
            weight = int(weight * (2 ** decimal_width))

            # Convert to binary
            if (weight < 0):
                # Take 2's complement
                weight = ''.join(['1' if bit == '0' else '0' for bit in bin(weight)[3:]])
                weight_length = len(weight)
                weight_complement = bin(int(weight, 2) + 1)[2:]

                weight = f"{'1' * (data_width - weight_length)}{weight_complement.zfill(weight_length)}"
            else:
                weight = bin(weight)[2:].zfill(data_width)

            # Write back to file
            weight_lines.append(weight + '\n')

        # Write back to file
        with open('rom/' + file + str(weight_count) + '.mif', 'w') as f:
            f.writelines(weight_lines)

        # Increment weight count
        weight_count += 1