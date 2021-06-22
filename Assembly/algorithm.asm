nop
nop
sub $6, $6, $6 # Reseteamos la dirección a la que estamos apuntando ($6)
nop
nop
mult $6, $7, $3 # Multiplicar 'Y' por 10 y guardarlo en $6
nop
nop
add $6, $6, $2 # Sumar $6 + 'X' ($2)
nop
nop
lw $8, $6, 0 # Cargar lo que hay en la direccion calculada ($6)
nop
nop
beq $8, $4, 7 # Comparar $8 con el source ($4), si son iguales, modificamos memoria
nop
nop
nop
j 25 # Ignorar modificar memoria, si no es igual a source
nop
nop
nop
sw $5, $6, 0 # Modificar memoria a target
nop
nop
sub $9, $9, $9 # Reseteamos $9 (auxiliar de slt)
nop
nop
slti $9, $2, 9 # slt con 'X' y 9
nop
nop
beq $9, $1, 27 # Si x < 9, x++, ir al inicio
nop
nop
nop
sub $9, $9, $9 # Reseteamos $9 (auxiliar de slt)
nop
nop
slti $9, $3, 9 # slt con 'Y' y 9
nop
nop
beq $9, $1, 7 # Si y < 9, x=0; y++; ir al inicio, si no FIN
nop
nop
nop
j 65 # FIN
nop
nop
nop
sub $2, $2, $2 # 'X' = 0
nop
nop
addi $3, $3, 1 # 'Y' ++
nop
nop
j 0 # Bucle
nop
nop
nop
addi $2, $2, 1 # 'X' ++
nop
nop
j 0 # Bucle
nop
nop
nop
nop
nop
j 65 # FIN
nop
nop
nop
