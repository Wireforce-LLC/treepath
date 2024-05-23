import os.path

formated = []
file_name = "/etc/nginx/routes.trp"

if not file_name.endswith(".trp"):
    file_name = file_name + ".trp"

if not os.path.isfile(file_name):
    print("File not found: " + file_name + ". Creating...")
    f = open(file_name, "w+")
    f.write("")
    f.close()
    print("File created: " + file_name)

if not os.path.getsize(file_name):
    print("File is empty: " + file_name)

with open(file_name, "r+") as f:
    print("File found: " + file_name + ". Validating...")
    content = f.readlines()

    if not content:
        print("File is empty: " + file_name + ". Nothing to validate")

    for line in content:
        print("Validating line: " + line)
        if str(line).strip() == '':
            print("Skipping empty line")
            continue
            
        if " => " in line:
            print("Appending line: " + line)
            formated.append(line)

if not formated:
    print("No lines to write to file: " + file_name)
    exit(0)

print("Writing to file: " + file_name)
with open(file_name, "w+") as f:
    f.writelines(formated)