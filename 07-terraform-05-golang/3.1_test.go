package main

import (
	"testing"
)

func TestTableConvert(t *testing.T) {
	var tests = []struct {
		input    float64
		expected float64
	}{
		{1, 0.3048},
		{2, 0.6096},
		{3, 0.9144000000000001},
		{10, 3.048},
	}

	for _, test := range tests {
		if output := Convert(test.input); output != test.expected {
			t.Error("Test Failed: {} inputted, {} expected, recieved: {}", test.input, test.expected, output)
		}
	}
}
