package main

import "fmt"

func main() {
	a := [5]int{1, 2, 3, 4, 5}

	for i, x := range a {
		fmt.Println("Element", i, "is", x)
	}
}
