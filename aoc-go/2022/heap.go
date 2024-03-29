package solutions

type Heap[T any] struct {
	items []T
	less  func(a, b T) bool
	max   int
}

func NewHeap[T any](max int, less func(a, b T) bool) Heap[T] {
	return Heap[T]{
		items: []T{},
		less:  less,
		max:   max,
	}
}

func (h *Heap[T]) Push(k T) {
	h.items = append(h.items, k)
	h.heapify_up(len(h.items) - 1)
	if h.max > 0 && len(h.items) > h.max {
		h.Pop()
	}
}

func (h *Heap[T]) heapify_down(index int) {
	lastIndex := len(h.items) - 1
	l, r := left(index), right(index)
	to_compare := 0
	for l <= lastIndex {
		if l == lastIndex || !h.less(h.items[l], h.items[r]) {
			to_compare = l
		} else {
			to_compare = r
		}
		if h.less(h.items[index], h.items[to_compare]) {
			h.swap(index, to_compare)
			index = to_compare
			l, r = left(index), right(index)
		} else {
			return
		}
	}
}

func (h *Heap[T]) heapify_up(index int) {
	for h.less(h.items[parent(index)], h.items[index]) {
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

func (h *Heap[T]) swap(i, j int) {
	h.items[i], h.items[j] = h.items[j], h.items[i]
}

func (h *Heap[T]) Pop() T {
	k := h.items[0]
	l := len(h.items) - 1
	h.items[0] = h.items[l]
	// nil when T is pointer
	var n T
	h.items[l] = n
	h.items = h.items[:l]
	h.heapify_down(0)
	return k
}

func (h *Heap[T]) Len() int {
	return len(h.items)
}
