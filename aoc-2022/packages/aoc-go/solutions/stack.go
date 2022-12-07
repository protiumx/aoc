package solutions

type Stack[V any] struct {
	values []V
}

func NewStack[V any]() *Stack[V] {
	return &Stack[V]{
		values: make([]V, 0),
	}
}

func (s *Stack[V]) Push(value V) {
	s.values = append(s.values, value)
}

func (s *Stack[V]) Pop() (value V, ok bool) {
	if len(s.values) == 0 {
		ok = false
		return
	}
	value = s.values[len(s.values)-1]
	s.values = s.values[0 : len(s.values)-1]
	return value, true
}

func (s *Stack[V]) Peek() (value V, ok bool) {
	if len(s.values) == 0 {
		ok = false
		return
	}
	value = s.values[len(s.values)-1]
	return value, true
}

func (s *Stack[V]) Size() int {
	return len(s.values)
}
