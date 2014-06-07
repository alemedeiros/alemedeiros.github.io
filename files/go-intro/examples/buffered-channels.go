package main

import (
	"fmt"
	"time"
)

func produce(id, n int, ch chan<- int) {
	for i := 0; i < n; i++ {
		val := i * id
		ch <- val
		fmt.Println(id, "produced", val)
	}
}

func main() {
	ch := make(chan int, 2)

	go produce(42, 4, ch)

	time.Sleep(100 * time.Millisecond)
	for i := 0; i < 4; i++ {
		val := <-ch
		fmt.Println("Element", i, "is", val)
	}
}
