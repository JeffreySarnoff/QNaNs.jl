using QNaNs
using Base.Test

@test isnan(qnan(5)) == true
@test isnan(qnan(Int32(5))) == true
@test isnan(qnan(Int16(5))) == true

@test typeof(qnan(5)) == Float64
@test typeof(qnan(Int32(5))) == Float32
@test typeof(qnan(Int16(5))) == Float16

@test qnan(qnan(-22)) == -22
@test qnan(qnan(Int32(-22))) == -22
@test qnan(qnan(Int16(-22))) == -22

