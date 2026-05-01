using Test

if !isdefined(Main, :test_functions)
    include("test_utils.jl")
end

using MicroMagnetic
#@using_gpu()

function test_hystersis(; driver="SD")
    mesh = FDMesh(; nx=20, ny=10, nz=2, dx=5e-9, dy=5e-9, dz=5e-9)
    sim = Sim(mesh; name="hysteresis_llg", driver=driver)
  
    set_Ms(sim, 8.0e5)

    add_exch(sim, 1.3e-11)
    add_anis(sim, 1e5; axis=(1, 0, 0))

    init_m0(sim, (1,1,1))

    # Run Hysteresis Loop
    Hs = [i * mT for i in -50:1:50]
    tilt_angle = 1 / 180 * pi
    direction = (cos(tilt_angle), sin(tilt_angle), 0)
    hysteresis(sim, Hs, direction=direction, full_loop=false, stopping_dmdt=0.1, output="vts")
    
    
    Hs = [(0, i*mT, 0) for i = -100:10:100]
    hysteresis(sim, Hs; full_loop=true)     
    #  
end

@using_gpu()
test_functions("Hysteresis", test_hystersis)

