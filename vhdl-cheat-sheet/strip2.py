import os

for file_path in os.listdir("hdl_files"):

    with open(f"hdl_files\\{file_path}", 'r') as f:
        lines = f.readlines()

    with open(f"hdl_files\\{file_path}", 'w') as f:
        for line in lines[0::2]:
            f.write(line)