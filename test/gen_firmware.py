def process_file(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for i, line in enumerate(infile):
            # Remove text after double slashes
            line = line.split('//')[0]
            # Trim spaces at the end of the line
            line = line.rstrip()
            # Write the processed line to the output file
            outfile.write(line)
            # Add a new line after each line except the last line
            if i != (num_lines(input_file) - 1):
                outfile.write('\n')

def num_lines(file_path):
    with open(file_path, 'r') as file:
        return sum(1 for line in file)

process_file("firmware.txt", "firmware.mem");
process_file("firmware_aes.txt", "firmware_aes.mem");
