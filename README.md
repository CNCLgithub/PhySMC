# PhySMC.jl - Physical simulation safe for Probabalistic programming

> NOTE!: this is a work in progress and the API is NOT stable

The purpose of PhySMC is to properly interface physics engines with probablistic programming. Probabalistic programming, especially of the flavor found in [Gen](https://www.gen.dev/), composes stochastic computation with deterministic or [pure functions](https://en.wikipedia.org/wiki/Pure_function) (e.g., every time f is called with argument x you get the same result y). However, physics engines often rely in interal state (usually to cache computations) which can pose an issue for integrating them with Gen. For example, generative multiple traces using the same engine context (such as a particle filter) can lead to unintended side-effects when using `Gen.update`.

PhySMC provides and interface where calls to physics engines and retrieval / manipulation of state behaves in a pure way.

The interace is defined in https://github.com/CNCLgithub/PhySMC/blob/master/src/PhySMC.jl
with the main function being `step`

```julia
"""
     step(sim::PhySim, st::PhyState)::SimState

Performs a stateless evolution of the simulation state.
"""
function step(sim::PhySim, st::PhyState) end
```
where sim::PhySim is some simulation backend and st::PhyState is some state for that backend.

The default implementation of `step` relies on two helper funtions that can be broadly useful in generative modeling:
- `sync!`
- `forward_step`

```julia
function step(sim::PhySim, st::PhyState)
    sync!(sim, st)
    new_st = forward_step(sim, st)
end
```
where these functions can be dispatched to particular simulator backends

```julia
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
```
## Backends

### Available
- [PhyBullet](https://github.com/CNCLgithub/PhyBullet/tree/master) : Backend for the [bullet physics engine (via pybullet)](https://pybullet.org/wordpress/)

### Planned
- Taichi : Backend for [taichi physics](https://github.com/taichi-dev/taichi)

Contributions are always welcome!
Documentation is a work in progress, please refer to docstrings in `src/PhySMC.jl` in the meantime. 
