package main

import "fmt"

func main() {
	for i := 1; i < 100; i++ {
		if i%3 == 0 {
			fmt.Println(i)
		}
	}
	for j := 3; j < 100; j = j + 3 {
		fmt.Println(j)
	}
}
