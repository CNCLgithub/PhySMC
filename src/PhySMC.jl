module PhySMC

using Gen

export PhySim,
    PhyState,
    Element,
    ElemState,
    ElemLatents,
    step,
    sync!,
    forward_step

""" Parameters for a physics engine """
abstract type PhySim end

""" The result of simulation """
abstract type PhyState{T<:PhySim} end

""" A component in simulation """
abstract type Element{T<:PhySim} end

""" The state of an element """
abstract type ElemState{T<:Element} end

""" The latents describing the dynamics of an element """
abstract type ElemLatents{T<:Element} end

"""
     step(sim::PhySim, st::PhyState)::SimState

Performs a stateless evolution of the simulation state.
"""
function step(sim::PhySim, st::PhyState)
    sync!(sim, st)
    new_st = forward_step(sim, st)
end


"""
    sync!(sim::PhySim, st::PhyState)::Nothing

Synchronizes the context within `sim` using `st`.
"""
function sync! end

"""
    forward_step(sim::PhySim)::PhyState

Resolves physical interactions and obtains the next state representation.
"""
function forward_step end

end # module PhySMC
