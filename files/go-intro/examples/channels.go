package main

import (
	"fmt"
	"time"
)

func say(s string, done chan bool) {
	for i := 0; i < 3; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
	done <- true
}

func main() {
	done := make(chan bool)
	go say("Hello, World!", done)

	if <-done {
		fmt.Println("Done :)")
	}
}
