import re

def main():
	file_name = input("Ingresa el nombre del archivo --> ")
	#file_name = "example.asm"
	#try
	file = open(file_name, "r")
	lines = file.readlines()
	file.close()

	open(file_name+"_converted.txt", "w").close ## borrar contenido
	new_file = open(file_name+"_converted.txt", "a")

	for i in lines:
		op_code = parse(i[:-1])

		if (op_code != ""): # Solo si es opcode
			print(op_code, end="\n") ## mostrar en consola

			## escribir en el archivo, dividirlo en 4 para el mips32
			new_file.write(op_code[0:8]+"\n")
			new_file.write(op_code[8:16]+"\n")
			new_file.write(op_code[16:24]+"\n")
			new_file.write(op_code[24:32]+"\n")

	new_file.close()
	print("\nTu archivo ha sido convertido correctamente!!\n")
	input()



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
		"slt": "101010",
		"mult": "011000"
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
			dest = bin(dest_a, 5) # to 5 bits binary
			dest_a = "\$"+dest_a # concatenar '$'

			# GET: src1
			pattern = op_code_a+" "+dest_a+", \$(.*)," # patterntron a buscar
			src1_a = re.search(pattern, code).group(1)
			src1 = bin(src1_a, 5) # to 5 bits binary
			# add '$'
			src1_a = "\$"+src1_a # concatenar '$'

			# GET: src2
			pattern = op_code_a+" "+dest_a+", "+src1_a+", \$(.*)" # patron a buscar
			src2_a = re.search(pattern, code).group(1)
			src2 = bin(src2_a, 5) # to 5 bits binary
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
			rt = bin(rt_a, 5) # to 5 bits binary
			rt_a = "\$"+rt_a # concatenar '$'

			# GET: rs
			pattern = op_code_a+" "+rt_a+", \$(.+?)," # patron a buscar
			rs_a = re.search(pattern, code).group(1)
			rs = bin(rs_a, 5) # to 5 bits binary
			rs_a = "\$"+rs_a # concatenar '$'

			# GET: inmediate
			pattern = op_code_a+" "+rt_a+", "+rs_a+", (.*)" # patron a buscar
			inmediate_a = re.search(pattern, code).group(1)
			inmediate = bin(inmediate_a, 16) # to 16 bits binary

			return op_code+rs+rt+inmediate

	# Es J
	if "j " in code:
		op_code = "000010"
		# GET: inmediate**
		pattern = "j (.*)" # patron a buscar
		inmediate_a = re.search(pattern, code).group(1)
		inmediate = bin(inmediate_a, 26)# to 16 bits binary
		return op_code+inmediate

	if "beq " in code:
		op_code = "000100"

		# GET: rs
		pattern = "beq \$(.+?)," # patron a buscar
		rs_a = re.search(pattern, code).group(1)
		rs = bin(rs_a, 5) # to 5 bits binary
		rs_a = "\$"+rs_a # concatenar '$'

		# GET: rt
		pattern = "beq "+rs_a+", \$(.+?)," # patron a buscar
		rt_a = re.search(pattern, code).group(1)
		rt = bin(rt_a, 5) # to 5 bits binary
		rt_a = "\$"+rt_a # concatenar '$'

		# GET: rt
		pattern = "beq "+rs_a+", "+rt_a+", (.*)" # patron a buscar
		offset_a = re.search(pattern, code).group(1)
		offset = bin(offset_a, 16) # to 16 bits binary
		offset_a = "\$"+rt_a # concatenar '$'

		return op_code+rs+rt+offset

	return "" # Se omite si todo falla

def bin(num, bits): # Funcion para convertir entero a binario
	# Normal
	if int(num) >= 0:
		return format(int(num), "0"+str(bits)+"b")
	#Twos complement
	n = format(int(int(num)+1), "0"+str(bits)+"b")
	new = ""
	for i in range(len(n)):
		if (n[i] == "1"):
			new+="0"
		else:
			new+="1"
	return new

if __name__ == "__main__":
	main()