package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := x[0]
	for _, value := range x {
		if value < min {
			min = value
		}
	}
	fmt.Printf("Наименьше число в массиве равно %v", min)
}
