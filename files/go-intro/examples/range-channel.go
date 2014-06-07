package main

import "fmt"

func produce(id, n int, ch chan<- int) {
	for i := 0; i < n; i++ {
		val := i * id
		ch <- val
		fmt.Println(id, "produced", val)
	}
	close(ch)
}

func main() {
	ch := make(chan int, 2)

	go produce(42, 4, ch)

	for val := range ch {
		fmt.Println("Element is", val)
	}
}
