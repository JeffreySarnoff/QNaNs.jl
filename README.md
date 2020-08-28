# QNaNs.jl
Simplifies the use of quiet NaNs to propagate information from within numerical computations.

----
#### Copyright © 2016-2020 by Jeffrey Sarnoff.  This material is released under the MIT license.

&nbsp;&nbsp; [![Build Status](https://travis-ci.org/JeffreySarnoff/QNaNs.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/QNaNs.jl)

----

#### Quick Look

```julia
> Pkg.add("QNaNs")
```
```julia
> using QNaNs
> qnan_a = qnan(36)
NaN
> payload = qnan(qnan_a)
36
> typeof(qnan_a)
Float64
> isnan(qnan_a), isnan(NaN)   # quiet NaNs are NaNs
true, true

> qnan_b = qnan(-36)
> qnan(qnan_b)
-36
> signbit(qnan_a), signbit(qnan_b)
false, true


# works with Float64, Float32 and Float16

> qnan_b = qnan(Int32(-77))
NaN32
> payload = qnan(qnan_b); payload, typeof(payload)
-77, Int32

> qnan_c = qnan(Int16(-77)); payload16 = qnan(qnan_c);
> qnan_c, typeof(qnan_c), payload16, typeof(payload16)
NaN16, Float16, -77, Int16

```


##### William Kahan on QNaNs

NaNs propagate through most computations. Consequently they do get used. ... they are needed only for computation, with temporal sequencing that can be hard to revise, harder to reverse. NaNs must conform to mathematically consistent rules that were deduced, not invented arbitrarily ...

NaNs [ give software the opportunity, especially when searching ] to follow an unexceptional path ( no need for exotic control structures ) to a point where an exceptional event can be appraised ... when additional evidence may have accrued ...  NaNs [have] a field of bits into which software can record, say, how and/or where the NaN came into existence. That [can be] extremely helpful [in] “Retrospective Diagnosis.”

-- IEEE754 Lecture Notes (highly redacted)


##### Quiet NaNs were designed to propagate information from within numerical computations

The payload for a Float64 qnan is an integer [-(2^51-1),(2^51-1)]  
The payload for a Float32 qnan is an integer [-(2^22-1),(2^22-1)]  
The payload for a Float16 qnan is an integer [-(2^9-1),(2^9-1)]  

Julia uses a payload of zero for NaN, NaN32, NaN16.

#### About QNaN Propogation

A QNaN introduced into a numerical processing sequence usually will propogate along the computational path without loss of identity unless another QNaN is substituted or an second QNaN occurs in an arithmetic expression.

When two qnans are arguments to the same binary op, Julia propagates the qnan on the left hand side. 
```julia
> using QNaNs
> function test()
    lhs = qnan(-64)
    rhs = qnan(100)
    (qnan(lhs-rhs)==qnan(lhs), qnan(rhs/lhs)==qnan(rhs))
  end;
> test()
(true, true)
```


References:

[William Kahan's IEEE754 Lecture Notes](http://www.eecs.berkeley.edu/~wkahan/ieee754status/IEEE754.PDF)
