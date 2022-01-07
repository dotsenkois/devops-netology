package main

import "fmt"

func getMin(array []int) (output int) {
	output = array[0]
	for _, value := range array {
		if value < output {
			output = value
		}
	}
	return output
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	fmt.Printf("Наименьше число в массиве равно %v\n", getMin(x))
}
