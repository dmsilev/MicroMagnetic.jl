# @title Magnetic Vortex (FEM)
# @description Create and relax a magnetic vortex
# @tags tutorial fem

# Create Mesh
mesh = FEMesh("nanodot.mesh")

# Create Simulation
sim = Sim(mesh; name="vortex", driver="SD")

# Set Saturation Magnetization
set_Ms(sim, 8e5)

# Initialize Magnetization
init_m0(sim, vortex(p=1, c=-1))

# Add Exchange Interaction
add_exch(sim, 1.3e-11)

# Add Demagnetization
add_demag(sim)

# Relax System
relax(sim; stopping_dmdt=0.01)