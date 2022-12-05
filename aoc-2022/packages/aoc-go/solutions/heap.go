package solutions

type Heap struct {
	items   []int
	compare func(a, b int) bool
	max     int
}

func NewHeap(max int, compare func(a, b int) bool) Heap {
	return Heap{
		items:   []int{},
		compare: compare,
		max:     max,
	}
}

func (h *Heap) insert(k int) {
	h.items = append(h.items, k)
	h.heapify_up(len(h.items) - 1)
	if len(h.items) > h.max {
		h.pop()
	}
}

func (h *Heap) heapify_down(index int) {
	lastIndex := len(h.items) - 1
	l, r := left(index), right(index)
	to_compare := 0
	for l <= lastIndex {
		if l == lastIndex || !h.compare(h.items[l], h.items[r]) {
			to_compare = l
		} else {
			to_compare = r
		}
		if h.compare(h.items[index], h.items[to_compare]) {
			h.swap(index, to_compare)
			index = to_compare
			l, r = left(index), right(index)
		} else {
			return
		}
	}
}

func (h *Heap) heapify_up(index int) {
	for h.compare(h.items[parent(index)], h.items[index]) {
		h.swap(parent(index), index)
		index = parent(index)
	}
}

func parent(i int) int {
	return (i - 1) / 2
}

func left(i int) int {
	return i*2 + 1
}

func right(i int) int {
	return i*2 + 2
}

func (h *Heap) swap(i, j int) {
	h.items[i], h.items[j] = h.items[j], h.items[i]
}

func (h *Heap) pop() int {
	k := h.items[0]
	l := len(h.items) - 1
	h.items[0] = h.items[l]
	h.items = h.items[:l]
	h.heapify_down(0)
	return k
}