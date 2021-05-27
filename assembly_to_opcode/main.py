import re

def main():
	
	file_name = input("Ingresa el nombre del archivo --> "); print("")
	#file_name = "example.asm"
	try:
		file = open(file_name, "r")
		lines = file.readlines()
		file.close()

		open(file_name+"_converted.txt", "w").close ## borrar contenido
		new_file = open(file_name+"_converted.txt", "a")

		for i in lines:
			op_code = parse(i[:-1])

			if (op_code != ""): # Solo si es opcode
				print(op_code, end="\n") ## mostrar en consola
				new_file.write(op_code+"\n") ## escribir en el archivo

		new_file.close()
		print("\nTu archivo ha sido convertido correctamente!!\n")
		input()

	except:
		print("Error 404 !")
		input()

	"""
	assembly_code = "slt $31, $31, $31"
	op_code = parse(assembly_code)
	print(op_code)
	"""

def parse(code):
	# Default op code value
	op_code = ""
	# Get op_code, function
	op_000000 = ["add", "sub", "or", "and", "slt"]


	# IS NOP
	if (code == "nop"):
		return (32*"0")

	for i in op_000000:
		if i in code:
			op_code = "000000"
			shamt = "00000"
			op_code_a = i

			# Function
			switch = {
				"add": "100000",
				"sub": "100010",
				"or": "100101",
				"and": "100100",
				"slt": "101010"
			}
			funct = switch[i]
			break

	if (op_code == "000000"): # Si es add, sub, or, and, slt
		# GET: src1
		pattern = op_code_a+" \$(.+?)," # patron a buscar
		src1_a = re.search(pattern, code).group(1)
		src1 = format(int(src1_a), "05b") # to 5 bits binary
		src1_a = "\$"+src1_a # add '$'

		# GET: src2
		pattern = op_code_a+" "+src1_a+", \$(.*)," # patron a buscar
		src2_a = re.search(pattern, code).group(1)
		src2 = format(int(src2_a), "05b") # to 5 bits binary
		# add '$'
		src2_a = "\$"+src2_a # concatenar '$'

		# GET: dest
		pattern = op_code_a+" "+src1_a+", "+src2_a+", \$(.*)" # patron a buscar
		dest_a = re.search(pattern, code).group(1)
		dest = format(int(dest_a), "05b") # to 5 bits binary
		dest_a = "\$"+dest_a # concatenar '$'

		return op_code+src1+src2+dest+shamt+funct

	else:
		return "" # Se omite


if __name__ == "__main__":
	main()