package main

import "fmt"

func Convert(meters float64) (result float64) {
	result = meters * 0.3048
	return result
}

func main() {
	fmt.Print("Enter a distance in meters: ")
	var input float64
	fmt.Scanf("%f", &input)
	fmt.Printf("Distance in feet equal to %v feets", Convert(input))
}
