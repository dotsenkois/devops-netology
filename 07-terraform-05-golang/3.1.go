package main

import "fmt"

func main() {
	fmt.Print("Enter a distance in meters: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input * 0.3048

	fmt.Printf("Distance in feet equal to %v feets", output)
}
