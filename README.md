# QNaNs.jl
Simplifying use of quiet NaNs to propagate information from within numerical computations.
```ruby
                                                       Jeffrey Sarnoff © 2016-Mar-26 at New York
```

####Quick Look

```julia
> Pkg.add("QNaNs")
```
```julia
> using QNaNs
> a_qnan = qnan(36)
NaN
> typeof(a_qnan)
Float64
> payload = qnan(a_qnan)
36
> a_qnan = qnan(Int32(-77))
NaN32
> payload = qnan(a_nan); payload, typeof(payload)
-77, Int32
> isqnan(a_qnan), isqnan(NaN)
true, true
> isnan(a_qnan), isnan(NaN)   # quiet NaNs areNaNs
true, true
```

##### Quiet NaNs were designed to propagate information from within numerical computations


```julia
#=
  A float64 quiet NaN is represented with these 2^52-2 UInt64 hexadecimal patterns:
  (positive) UnitRange(0x7ff8000000000000,0x7fffffffffffffff) has 2^51-1 realizations
  (negative) UnitRange(0xfff8000000000000,0xffffffffffffffff) has 2^51-1 realizations
  A float32 quiet NaN is represented with these 2^23-2 UInt32 hexadecimal patterns:
  (positive) UnitRange(0x7fc00000,0x7fffffff) has 2^22-1 realizations
  (negative) UnitRange(0xffc00000,0xffffffff) has 2^22-1 realizations
  A float16 quiet NaN is represented with these 2^10-2 UInt16 hexadecimal patterns:
  (positive) UnitRange(0x7e00,0x7fff) has 2^9-1 realizations
  (negative) UnitRange(0xfe00,0xffff) has 2^9-1 realizations
  Julia appears to assign as NaNs quiet NaNs with a payload of zero:
  0xfff8000000000000, 0xffc00000, 0xfe00, 0x7ff8000000000000, 0x7fc00000, 0x7e00.
=#
```

####About QNaN Propogation

A QNaN introduced into a numerical processing sequence usually will propogate along the computational path without loss of identity unless another QNaN is substituted or an second QNaN occurs in an arithmetic expression.

When two qnans are arguments to the same binary op, Julia propagates the qnan on the left hand side. 
```julia
> using QNaN
> function test()
    lhs = qnan(-64)
    rhs = qnan(100)
    (qnan(lhs-rhs)==qnan(lhs), qnan(rhs/lhs)==qnan(rhs))
  end;
> test()
(true, true)
```

When the information carried is costly to aquire, and one of two payload is usually the more importantd,  a pairing function may propogate more than one payload.  This is easiest whith smaller payloads. Pairing starts with zero and stops as zero is unpaired.  The initial pair: ``pair(pair(zero, first_payload),second_payload)``.


#####William Kahan on QNaNs

NaNs propagate through most computations. Consequently they do get used. ... they are needed only for computation, with temporal sequencing that can be hard to revise, harder to reverse. NaNs must conform to mathematically consistent rules that were deduced, not invented arbitrarily ...

NaNs [ give software the opportunity, especially when searching ] to follow an unexceptional path ( no need for exotic control structures ) to a point where an exceptional event can be appraised ... when additional evidence may have accrued ...  NaNs [have] a field of bits into which software can record, say, how and/or where the NaN came into existence. That [can be] extremely helpful [in] “Retrospective Diagnosis.”

-- IEEE754 Lecture Notes (highly redacted)

References:

[William Kahan's IEEE754 Lecture Notes](http://www.eecs.berkeley.edu/~wkahan/ieee754status/IEEE754.PDF)

["An Elegant Pairing Function" by Matthew Szudzik](http://szudzik.com/ElegantPairing.pdf)



When the information carried is costly to aquire, and one of two payload is usually the more importantd,  a pairing function may propogate more than one payload.  This is easiest whith smaller payloads. Pairing starts with zero and stops as zero is unpaired.  The initial pair: ``pair(pair(zero, first_payload),second_payload)``.


```julia
> using QNaN
> function test_rhs_of_subtract()
    lhs = qnan(-64)
    rhs = qnan(100)
    (qnan(lhs-rhs)==qnan(lhs), qnan(rhs-lhs)==qnan(rhs))
  end;
> test_rhs_of_subtract()
(true, true)
```


#####William Kahan on QNaNs

NaNs propagate through most computations. Consequently they do get used. ... they are needed only for computation, with temporal sequencing that can be hard to revise, harder to reverse. NaNs must conform to mathematically consistent rules that were deduced, not invented arbitrarily ...

NaNs [ give software the opportunity, especially when searching ] to follow an unexceptional path ( no need for exotic control structures ) to a point where an exceptional event can be appraised ... when additional evidence may have accrued ...  NaNs [have] a field of bits into which software can record, say, how and/or where the NaN came into existence. That [can be] extremely helpful [in] “Retrospective Diagnosis”

-- IEEE754 Lecture Notes (highly redacted)

References:

[William Kahan's IEEE754 Lecture Notes](http://www.eecs.berkeley.edu/~wkahan/ieee754status/IEEE754.PDF)

["An Elegant Pairing Function" by Matthew Szudzik](http://szudzik.com/ElegantPairing.pdf)


