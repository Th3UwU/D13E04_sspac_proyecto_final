#include <stdio.h>
#include <stdlib.h>

char A[10][10] =
{
	{'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'},
	{'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'},
	{'O', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'O', 'O', 'O'},
	{'Y', 'O', 'O', 'O', 'O', 'O', 'Y', 'O', 'O', 'O'},
	{'Y', 'O', 'O', 'O', 'O', 'O', 'Y', 'O', 'O', 'O'},
	{'Y', 'O', 'O', 'O', 'O', 'O', 'O', 'Y', 'O', 'O'},
	{'O', 'Y', 'O', 'O', 'O', 'O', 'O', 'Y', 'O', 'O'},
	{'O', 'Y', 'Y', 'O', 'O', 'O', 'Y', 'O', 'O', 'O'},
	{'O', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'O', 'O', 'O'},
	{'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O'}
};


void update_screen(); // Mostrar la pantalla
void flood();
void fill();

int main()
{
	update_screen();
	system("pause");
	fill(4, 4, 'B');
	update_screen();
	system("pause");

	return 0;
}

void fill(int x, int y, char target) // posicion y color a pintar
{
	char source = A[y][x]; // Color que vamos a cambiar a target
	flood(x, y, target, source);
}

void flood(int x, int y, char target, char source)
{
	A[y][x] = target; // Pintar

	if (A[y+1][x] == source) flood(x, y+1, target, source); // ABAJO

	if (A[y][x+1] == source) flood(x+1, y, target, source); // DERECHA

	if (A[y-1][x] == source) flood(x, y-1, target, source); // ARRIBA

	if (A[y][x-1] == source) flood(x-1, y, target, source); // IZQUIERDA
}

void update_screen()
{
	system("cls");
	for (int y = 0; y < 10; y++)
	{
		for (int x = 0; x < 10; x++)
		{
			printf("%c", A[y][x]);
		}
		printf("\n");
	}
}
