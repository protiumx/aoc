package solutions

import "testing"

func TestHeap(t *testing.T) {
	h := NewHeap(-1, func(a, b int) bool { return a < b })
	h.Push(10)
	h.Push(-2)
	h.Push(7)

	expected := []int{10, 7, -2}
	for _, n := range expected {
		if top := h.Pop(); top != n {
			t.Errorf("expected %d got %d", n, top)
		}
	}
}
