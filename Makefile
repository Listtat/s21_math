TARGET = math

CC = gcc
CFLAGS = -Wall -Werror -Wextra -g

SRCS = s21_math.c

TESTS = s21_math_test.c
HEADERS = s21_$(TARGET).h

OBJ = $(patsubst %.c, %.o, $(SRCS))
TESTS_OBJ = $(patsubst %.c, %.o, $(TESTS))

OS = $(shell uname)

ifeq ($(OS), Linux)
	LINUX_LIBS=-lsubunit -lrt -lpthread -lm
endif

.PHONY: all clean test s21_$(TARGET).a gcov_report

all: s21_$(TARGET).a test gcov_report clean

%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

s21_$(TARGET).a: $(OBJ)
	@ar -rcs s21_$(TARGET).a $(OBJ)

test: s21_$(TARGET).a $(TESTS_OBJ) $(HEADERS)
	@$(CC) --coverage s21_$(TARGET).a $(TESTS_OBJ) -o s21_math_test -lcheck $(LINUX_LIBS)

gcov_report: $(SRCS) $(TESTS) $(HEADRES)
	@$(CC) $(SRCS) $(TESTS) -o s21 -lcheck  $(LINUX_LIBS) -fprofile-arcs -ftest-coverage
	@./s21
	@lcov -c -d . -o s21.info
	@genhtml s21.info -o report
	@open report/index.html

clean:
	@rm -rf *.o *.gcno *.gcda *.info