using Distributions

function test_rand(;p=nothing, K=5, nsamp=10000)
    isnothing(p) && (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    o = rand(d, nsamp)
    display(o[:, 1:5])
    y = counts(o[1, :], 1:length(p))./nsamp
    return (abs.(p - y)./p)*100
end

function test_part_rand(;p=nothing, K=5, n=3, nsamp=10000)
    isnothing(p) && (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    o = part_rand(d, n, nsamp)
    display(o[:, 1:5])
    y = counts(o[1, :], 1:length(p))./nsamp
    return (abs.(p - y)./p)*100
end

function test_ro_trans(;p=nothing, K=5)
    !isnothing(p) || (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    o = rand(d)
    println("original order")
    println(o)
    r = order_to_ranking(o, K)
    println("original order to ranking")
    println(r)
    o1 = zeros(eltype(o), K)
    ranking_to_order!(r, o1)
    println("back to order in-place")
    println(o1)
    r1 = zeros(eltype(r), K)
    order_to_ranking!(o1, r1, K)
    println("back to ranking in-place")
    println(r1)
    println("orders match")
    println(all(o .== o1))
    println("rankings match")
    println(all(r .== r1))
    return all(o .== o1)
end

function test_ro_trans_in_place(;p=nothing, n=3, K=5)
    !isnothing(p) || (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    o = part_rand(d, n, 1)
    o = o[:, 1]
    println("original order")
    println(o)
    r = order_to_ranking(o, n)
    println("original order to ranking")
    println(r)
    o1 = zeros(eltype(o), K)
    ranking_to_order!(r, o1)
    println("back to order in-place")
    println(o1)
    r1 = zeros(eltype(r), K)
    order_to_ranking!(o1, r1, n)
    println("back to ranking in-place")
    println(r1)
    println("orders match")
    println(all(o .== o1))
    println("rankings match")
    println(all(r .== r1))
    return all(o .== o1)
end

function test_logpdf(;p=nothing, n=3, K=5)
    !isnothing(p) || (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    # whole order first
    o = rand(d)
    ll = logpdf(d, o)
    println(p)
    println(o)
    println(ll)
    # now a partial order
    o = part_rand(d, n, 1)
    o = o[:, 1]
    ll = logpdf(d, o)
    println(p)
    println(o)
    println(ll)
end

function test_fit_mle(;p=nothing, n=3, K=5, nsamp=150)
    !isnothing(p) || (p = rand(Uniform(), K))
    p = p./sum(p)
    d = PlackettLuce(p)
    # whole order first
    o = rand(d, nsamp)   
    pl_mle = fit_mle(PlackettLuce, o)
    println(d)
    println(pl_mle)
    # partial order
    o = part_rand(d, n, nsamp)
    pl_mle = fit_mle(PlackettLuce, o)
    println(d)
    println(pl_mle)
end