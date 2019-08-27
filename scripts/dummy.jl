using TulipBenchmarks

println("Dummy benchmark")
run_dummy([:TLP, :MSK])

println("\n\nNetlib benchmarks")
run_netlib([:TLP, :MSK])