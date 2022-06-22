package main

import (
	"testing"
)

func TestTableGetMin(t *testing.T) {
	var tests = []struct {
		input    []int
		expected int
	}{
		{[]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}, 9},
		{[]int{1, 2, 3, 4, 5}, 1},
		{[]int{2, 3, 4, 5}, 2},
		{[]int{3, 4, 5}, 3},
	}

	for _, test := range tests {
		if output := getMin(test.input); output != test.expected {
			t.Error("Test Failed: {} inputted, {} expected, recieved: {}", test.input, test.expected, output)
		}
	}
}
