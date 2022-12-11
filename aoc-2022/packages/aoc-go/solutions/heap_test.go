package solutions

import "testing"

func TestHeap(t *testing.T) {
	h := NewHeap(-1, func(a, b int) bool { return a < b })
	h.insert(10)
	h.insert(-2)
	h.insert(7)

	expected := []int{10, 7, -2}
	for _, n := range expected {
		if top := h.pop(); top != n {
			t.Errorf("expected %d got %d", n, top)
		}
	}
}
