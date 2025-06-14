import os
import subprocess
import re

def extract_function_names(c_file_path):

    function_names = set()

    function_pattern = re.compile(
        r'\b(?:float|int|void|double|bool|char)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\('
    )

    try:
        with open(c_file_path, 'r', encoding='utf-8') as f:
            content = f.read()

            # Find all matches in the file content
            # Each match will be a tuple: (return_type, function_name)
            matches = function_pattern.findall(content)

            for match in matches:
                # The function name is in the second capturing group (index 1)
                function_name = match
                function_names.add(function_name)

    except FileNotFoundError:
        print(f"Error: The file '{c_file_path}' was not found.")
    
    except Exception as e:
        print(f"An error occurred while reading the file: {e}")

    return function_names


def main():
    subprocess.run(["python3", "sintable.py"])
    subprocess.run(["python3", "costable.py"])
    subprocess.run(["python3", "tantable.py"])

    c_file = "./triangle_functions.c"
    output_file = "functions.txt"

    if not os.path.exists(c_file):
        print(f"Error: The input file '{c_file}' does not exist.")
        return

    print(f"Extracting function names from '{c_file}'...")
    names = extract_function_names(c_file)

    if names:
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                for name in sorted(list(names)):
                    f.write(name + '\n')
            print(f"Successfully extracted {len(names)} unique function names to '{output_file}'.")
        except IOError as e:
            print(f"Error writing to output file '{output_file}': {e}")
    else:
        print("No function names found matching the specified pattern.")

if __name__ == "__main__":
    main()

