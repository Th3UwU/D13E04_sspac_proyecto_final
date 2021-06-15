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
	assembly_code = "add $12, $3, $4"
	op_code = parse(assembly_code)
	print(op_code)
	"""

def parse(code):
	# Default op code value
	op_code = ""

	# IS NOP
	if (code == "nop"):
		return (32*"0")

	# TIPO R / 000000
	R_TYPE = {
		"add": "100000",
		"sub": "100010",
		"or": "100101",
		"and": "100100",
		"slt": "101010"
	}
	for i in R_TYPE:
		if i+" $" in code: # Por ejemplo --> "add $" y no confundir con "addi $"
			op_code = "000000"
			shamt = "00000"
			op_code_a = i
			# Function
			funct = R_TYPE[i]

			# GET: dest
			pattern = op_code_a+" \$(.+?)," # patron a buscar
			dest_a = re.search(pattern, code).group(1)
			dest = format(int(dest_a), "05b") # to 5 bits binary
			dest_a = "\$"+dest_a # concatenar '$'

			# GET: src1
			pattern = op_code_a+" "+dest_a+", \$(.*)," # patron a buscar
			src1_a = re.search(pattern, code).group(1)
			src1 = format(int(src1_a), "05b") # to 5 bits binary
			# add '$'
			src1_a = "\$"+src1_a # concatenar '$'

			# GET: src2
			pattern = op_code_a+" "+dest_a+", "+src1_a+", \$(.*)" # patron a buscar
			src2_a = re.search(pattern, code).group(1)
			src2 = format(int(src2_a), "05b") # to 5 bits binary
			src2_a = "\$"+src2_a # concatenar '$'

			return op_code+src1+src2+dest+shamt+funct

	# TIPO I
	I_TYPE = {
		"addi": "001000",
		"slti": "001010",
		"andi": "001100",
		"ori": "001101",
		"sw": "101011",
		"lw": "100011",
	}

	for i in I_TYPE:
		if i in code:
			op_code = I_TYPE[i]
			op_code_a = i

			# GET: rt
			pattern = op_code_a+" \$(.+?)," # patron a buscar
			rt_a = re.search(pattern, code).group(1)
			rt = format(int(rt_a), "05b") # to 5 bits binary
			rt_a = "\$"+rt_a # concatenar '$'

			# GET: rs
			pattern = op_code_a+" "+rt_a+", \$(.+?)," # patron a buscar
			rs_a = re.search(pattern, code).group(1)
			rs = format(int(rs_a), "05b") # to 5 bits binary
			rs_a = "\$"+rs_a # concatenar '$'

			# GET: inmediate
			pattern = op_code_a+" "+rt_a+", "+rs_a+", (.*)" # patron a buscar
			inmediate_a = re.search(pattern, code).group(1)
			inmediate = format(int(inmediate_a), "016b") # to 16 bits binary

			return op_code+rs+rt+inmediate

	# Es J
	if "j " in code:
		op_code = "000010"
		# GET: inmediate
		pattern = "j (.*)" # patron a buscar
		inmediate_a = re.search(pattern, code).group(1)
		inmediate = format(int(inmediate_a), "026b") # to 16 bits binary
		return op_code+inmediate

	return "" # Se omite


if __name__ == "__main__":
	main()