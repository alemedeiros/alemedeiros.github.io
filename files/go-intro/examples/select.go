package main

import "fmt"

func produce(id, n int, ch chan<- int) {
	for i := 0; i < n; i++ {
		val := i * id
		ch <- val
		fmt.Println("Producer", id, ":", val)
	}
}

func main() {
	ch1 := make(chan int, 2)
	ch2 := make(chan int, 2)

	go produce(1, 4, ch1)
	go produce(2, 4, ch2)

	for i := 0; i < 8; i++ {
		select {
		case val := <-ch1:
			fmt.Println("From 1:", val)
		case val := <-ch2:
			fmt.Println("From 2:", val)
		}
	}
}
