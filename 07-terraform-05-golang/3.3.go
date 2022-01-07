package main

import (
	"fmt"
)

func devidedByNumber(byNumber int) (array []int) {
	for i := 1; i <= 100; i++ {
		if i%byNumber == 0 {
			array = append(array, i)
		}
	}
	return array
}

func main() {
	fmt.Print("введите целое число для проверки кратности: \n")
	var input int
	fmt.Scanf("%d", &input)
	for _, v := range devidedByNumber(input) {
		fmt.Println(v)
	}
}
