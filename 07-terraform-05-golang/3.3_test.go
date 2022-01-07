package main

import (
	"testing"
)

func TestTableDevidedByNumber(t *testing.T) {
	var tests = []struct {
		input    int
		expected []int
	}{
		{3, []int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99}},
		{4, []int{4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100}},
		{5, []int{5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100}},
	}

	for _, test := range tests {
		output := devidedByNumber(test.input)
		for i := 0; i < len(test.expected); i++ {
			if output[i] != test.expected[i] {
				t.Error("Test Failed: {} inputted, {} expected, recieved: {}", test.input, test.expected, output)

			}
		}
	}
}
