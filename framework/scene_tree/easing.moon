m = math

_back = (t) ->
	s = 1.70158
	return t * t * ( (s+1) * t - s)


_bounce = (t) ->

	v = 1 - t
	c = 0
	d = 0

	if v < 1 / 2.75
		c = v
		d = 0

	elseif v < 2 / 2.75
		c = v - 1.5 / 2.75
		d = 0.75

	elseif v < 2.5 / 2.75
		c = v - 2.25 / 2.75
		d = 0.9375

	else
		c = v - 2.625 / 2.75
		d = 0.984375

	return 1 - (7.5625 * c * c + d)


_circ = (t) ->

	return 1 - m.sqrt(1 - t * t)


_cubic = (t) ->

	return t*t*t


_elastic = (t) ->

	pi = math.pi
	v = t - 1
	p = 0.3

	return -m.pow(2, 10 * v) * m.sin( (v - p / 4) * 2 * pi / p)


_expo = (t) ->

	if t == 0
		return 0
	else
		return m.pow(2, 10 / (t-1))


_linear = (t) ->

	return t


_quad = (t) ->

	return t*t


_quart = (t) ->

	return t*t*t*t


_quint = (t) ->

	return t*t*t*t*t


_sine = (t) ->

	return 1 - m.cos(t * m.pi / 2)


_create_easing = (f) ->
	return {

		In: (t) -> f(t)

		Out: (t) -> 1 - f(1 - t)

		InOut: (t) ->
			if t < 0.5
				f(2 * t) / 2
			else
				0.5 + ((1 - f(1 - (2 * t - 1))) / 2)

	}


--- Brief: Contains all easing functions.
---
--- Examples:
--- 	f1 = easing.elastic.in
--- 	f2 = easing.bounce.in_out
---
Easing = {
	Back: _create_easing _back
	Bounce: _create_easing _bounce
	Circ: _create_easing _circ
	Cubic: _create_easing _cubic
	Elastic: _create_easing _elastic
	Expo: _create_easing _expo
	Linear: _create_easing _linear
	Quad: _create_easing _quad
	Quart: _create_easing _quart
	Quint: _create_easing _quint
	Sine: _create_easing _sine
}

{ :Easing }
