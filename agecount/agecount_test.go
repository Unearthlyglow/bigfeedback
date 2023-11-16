package agecount

import (
	"testing"
)

func TestAgeCount(t *testing.T) {
	// Define a test case
	testInput := "30"
	expectedOutput := "30"

	// Call the AgeCount function with the test input
	actualOutput := AgeCount(testInput)

	// Check if the actual output matches the expected output
	if actualOutput != expectedOutput {
		t.Errorf("Expected output: %s, got: %s", expectedOutput, actualOutput)
	}
}
