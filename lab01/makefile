test_ll_cycle: test_ll_cycle.o ll_cycle.o
	gcc -o test_ll_cycle test_ll_cycle.o ll_cycle.o
test_ll_cycle.o: test_ll_cycle.c
	gcc -c test_ll_cycle.c
ll_cycle.o: ll_cycle.c ll_cycle.h
	gcc -c ll_cycle.c

clean:
	rm test_ll_cycle test_ll_cycle.o ll_cycle.o

